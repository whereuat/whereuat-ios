//
//  PushNotification.swift
//  whereuat
//
//  Created by Raymond Jacobson on 4/18/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation
import Contacts
import SlideMenuControllerSwift

/*
 * NotificationType represents two types of notifications, alerts and push notifications
 */
enum NotificationType {
    case Alert
    case PushNotification
}

/*
 * RequestType represents the two kinds of confirmed requests and an unknown request type
 */
enum RequestType {
    case AtRequest
    case AtResponse
    case UnknownRequest
}

/*
 * Notification represents a generic type that constructs and fires an alert or a push notification
 */
class Notification {
    var viewController: UIViewController?
    var notificationType: NotificationType!
    var data: [NSObject : AnyObject]!
    var requestType: RequestType!
    var alert: UIAlertController?
    var notification: UILocalNotification?
    
    let locManager = LocationManager.sharedInstance
    
    /*
     * init initialize a notification.
     * If the isAlert parameter is true, the notification is presented as an alert
     * @param data - the data payload for the push notification
     * @param notificationType - the type of notification to build
     */
    init(data: [NSObject : AnyObject], notificationType: NotificationType = NotificationType.PushNotification) {
        self.notificationType = notificationType
        self.data = data
        
        // Discover and set request type
        let requestType = self.data["type"]! as! String
        if (requestType == "AT_REQUEST") {
            self.requestType = RequestType.AtRequest
        } else if (requestType == "AT_RESPONSE") {
            self.requestType = RequestType.AtResponse
        } else {
            self.requestType = RequestType.UnknownRequest
        }
        
        // Build the correct notification type
        if (self.notificationType == NotificationType.PushNotification) {
            self.notification = self.constructPushNotification()
            
        } else {
            var vc = UIApplication.sharedApplication().keyWindow?.rootViewController
            while((vc!.presentedViewController) != nil){
                vc = vc!.presentedViewController
            }
            self.viewController = vc
            self.alert = self.constructAlertNotification()
        }
    }
    
    /*
     * findAndRegisterContact finds whether a phone number is already stored in contacts.
     * As a callback, it inserts a contact into the pending requests database table.
     * @param phoneNumber - string for the phone number to search by
     * @return (First, Last) names as a string type tuple
     */
    func findAndRegisterContact(phoneNumber: String) {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey]
        contactStore.requestAccessForEntityType(.Contacts, completionHandler: { (granted, error) -> Void in
            if granted {
                let predicate = CNContact.predicateForContactsInContainerWithIdentifier(contactStore.defaultContainerIdentifier())
                var contacts: [CNContact]! = []
                do {
                    contacts = try contactStore.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
                } catch {}
                for contact in contacts {
                    var phoneStr = ""
                    var number: CNPhoneNumber!
                    if contact.phoneNumbers.count > 0 {
                        number = contact.phoneNumbers[0].value as! CNPhoneNumber
                        phoneStr = number.stringValue.stringByReplacingOccurrencesOfString("-", withString: "")
                        phoneStr = phoneStr.stringByReplacingOccurrencesOfString("(", withString: "")
                        phoneStr = phoneStr.stringByReplacingOccurrencesOfString(")", withString: "")
                        phoneStr = phoneStr.stringByReplacingOccurrencesOfString(" ", withString: "")
                        // If the phone number we are searching for finds a match in the contacts, create a new contact
                        // and insert it into the contactRequestTable
                        if (phoneStr == phoneNumber) || (("+1" + phoneStr) == phoneNumber) {
                            let newContact = Contact(firstName: contact.givenName,
                                                     lastName: contact.familyName,
                                                     phoneNumber: phoneNumber)
                            Database.sharedInstance.contactRequestTable.insert(newContact)
                            return
                        }
                    }
                }
                let newContact = Contact(firstName: "", lastName: "", phoneNumber: phoneNumber)
                Database.sharedInstance.contactRequestTable.insert(newContact)
            }
        })
    }
    
    /*
     * constructPushNotification constructs a push notification taking into account the type of
     * push notification to send (AtRequest, AtResponse).
     * If a notification is received from a number not added to the contacts, it is inserted into
     * the contactRequestTable and a push notification is displayed. Subsequent requests are blocked.
     * @return a UILocalNotification to be fired
     */
    func constructPushNotification() -> UILocalNotification? {
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.userInfo = self.data
        
        if (self.requestType == RequestType.AtRequest) {
            let fromNumber = data["from-#"]! as! String
            let contactName = Database.sharedInstance.contactTable.getContact(fromNumber)?.getName()
            if (contactName != nil) {
                localNotification.alertBody = contactName! + Language.atRequest
                localNotification.fireDate = NSDate()
                localNotification.category = "REQUEST_LOCATION_CATEGORY";
            } else {
                // Check if the contact is already in a pending request. If it is not, create a push notification
                let contact = Database.sharedInstance.contactRequestTable.getContactRequest(fromNumber)
                if contact == nil {
                    localNotification.alertBody = fromNumber + Language.atRequest
                    // The pending request contact doesn't exist, check if we can find the number in the contact book
                    findAndRegisterContact(fromNumber)
                } else {
                    // A pending request for this contact already exists
                    return nil
                }
                localNotification.fireDate = NSDate()
                localNotification.category = "CONTACT_REQUEST_CATEGORY";
            }
            
        } else if (self.requestType == RequestType.AtResponse) {
            let fromNumber = data["from-#"]! as! String
            let contactName = Database.sharedInstance.contactTable.getContact(fromNumber)?.getName()
            let place = data["place"]! as! String
            if (contactName != nil) {
                localNotification.alertBody = contactName! + Language.atResponse + place
            } else {
                localNotification.alertBody = fromNumber + Language.atResponse + place
            }
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.fireDate = NSDate()
            localNotification.category = "RECEIVE_LOCATION_CATEGORY";
        }
        return localNotification
    }
    
    /*
     * constructAlertNotification constructs an alert notification
     * @return a UIAlertController to be transitioned to
     */
    func constructAlertNotification() -> UIAlertController? {
        let alertController = UIAlertController()

        if (self.requestType == RequestType.AtRequest) {
            let fromNumber = data["from-#"]! as! String
            let contactName = Database.sharedInstance.contactTable.getContact(fromNumber)?.getName()
            // We know the name of the contact sending an AtRequest because it has already been added to the Contacts Table
            if (contactName != nil) {
                alertController.message = contactName! + Language.atRequest
                alertController.addAction(UIAlertAction(title: "Ignore", style: UIAlertActionStyle.Default, handler: nil))
                alertController.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                    let number = self.data["from-#"]! as! String
                    self.locManager.sendLocation(number)
                }))
            } else {
                alertController.addAction(UIAlertAction(title: Language.openContactRequests, style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                    if let drawerViewController = ((self.viewController as! SlideMenuController).leftViewController as? DrawerViewController) {
                        // Change the active view controller to the ContactRequestsViewController
                        drawerViewController.changeViewController(Menu.ContactRequests)
                        // Set the drawer selector to the ContactRequestViewController
                        drawerViewController.changeMenuSelection(Menu.ContactRequests)
                    }
                }))
                // Check if the contact is already in a pending request. If it is not, create a push notification
                let contact = Database.sharedInstance.contactRequestTable.getContactRequest(fromNumber)
                if contact == nil {
                    alertController.message = fromNumber + Language.atRequest
                    // The pending request contact doesn't exist, check if we can find the number in the contact book
                    findAndRegisterContact(fromNumber)
                } else {
                    // A pending request for this contact already exists
                    return nil
                }
            }
        } else if (self.requestType == RequestType.AtResponse) {
            let fromNumber = data["from-#"]! as! String
            let contactName = Database.sharedInstance.contactTable.getContact(fromNumber)?.getName()
            let place = data["place"]! as! String
            if (contactName != nil) {
                alertController.message = contactName! + Language.atResponse + place
            } else {
                alertController.message = fromNumber + Language.atResponse + place
            }
            alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
        }
        return alertController
    }
    
    /*
     * fire fires the notification based on its notificationType
     */
    func fire() {
        var hasOnAutoShare = false
        // Check if auto share for the particular contact is enabled and send location if so
        if self.requestType == RequestType.AtRequest {
            let number = self.data["from-#"]! as! String
            let contact = Database.sharedInstance.contactTable.getContact(number)
            if contact != nil {
                if contact!.autoShare {
                    hasOnAutoShare = true
                    self.locManager.sendLocation(number)
                }
            }
        }
        // If the user is not on auto share, post the notification
        if !hasOnAutoShare {
            if(self.notificationType == NotificationType.PushNotification) {
                if self.notification != nil {
                    UIApplication.sharedApplication().scheduleLocalNotification(self.notification!)
                }
            } else {
                if self.alert != nil {
                    self.viewController!.presentViewController(self.alert!, animated: true, completion: nil)
                }
            }
        }
    }
    
    /*
     * getRequestLocationNotificationCategory sets up the push notification actions
     * for an AtRequest push notification message
     */
    static func getRequestLocationNotificationCategory() -> UIMutableUserNotificationCategory {
        let ignoreAction = UIMutableUserNotificationAction()
        ignoreAction.identifier = "IGNORE_IDENTIFIER"
        ignoreAction.title = "Ignore"
        ignoreAction.activationMode = .Background
        let sendAction = UIMutableUserNotificationAction()
        sendAction.identifier = "SEND_IDENTIFIER"
        sendAction.title = "Send"
        sendAction.activationMode = .Background
        
        let request_location_category = UIMutableUserNotificationCategory()
        request_location_category.identifier = "REQUEST_LOCATION_CATEGORY"
        request_location_category.setActions([sendAction, ignoreAction], forContext: .Default)
        request_location_category.setActions([sendAction, ignoreAction], forContext: .Minimal)
        
        return request_location_category
    }
    
    /*
     * getContactRequestNotificationCategory sets up the push notification actions
     * for an AtRequest push notification message when a contact has not been added
     */
    static func getContactRequestNotificationCategory() -> UIMutableUserNotificationCategory {
        let ignoreAction = UIMutableUserNotificationAction()
        ignoreAction.identifier = "IGNORE_IDENTIFIER"
        ignoreAction.title = "Ignore"
        ignoreAction.activationMode = .Background
        let openAction = UIMutableUserNotificationAction()
        openAction.identifier = "OPEN_CONTACT_REQUESTS_IDENTIFIER"
        openAction.title = "Open"
        openAction.activationMode = .Background
        
        let request_location_category = UIMutableUserNotificationCategory()
        request_location_category.identifier = "CONTACT_REQUEST_CATEGORY"
        request_location_category.setActions([openAction, ignoreAction], forContext: .Default)
        request_location_category.setActions([openAction, ignoreAction], forContext: .Minimal)
        
        return request_location_category
    }
    
    /*
     * getReceiveLocationNotificationCategory sets up the push notification actions
     * for an AtResponse push notification message
     */
    static func getReceiveLocationNotificationCategory() -> UIMutableUserNotificationCategory {
        let doneAction = UIMutableUserNotificationAction()
        doneAction.identifier = "DONE_IDENTIFIER"
        doneAction.title = "Done"
        doneAction.activationMode = .Background
        
        let received_location_category = UIMutableUserNotificationCategory()
        received_location_category.identifier = "RECEIVE_LOCATION_CATEGORY"
        received_location_category.setActions([doneAction], forContext: .Default)
        received_location_category.setActions([doneAction], forContext: .Minimal)
        
        return received_location_category
    }
}