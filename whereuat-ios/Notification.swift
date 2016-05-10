//
//  PushNotification.swift
//  whereuat
//
//  Created by Raymond Jacobson on 4/18/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation

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
     * constructPushNotification constructs a push notification
     * @return a UILocalNotification to be fired
     */
    func constructPushNotification() -> UILocalNotification {
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.userInfo = self.data
        
        if (self.requestType == RequestType.AtRequest) {
            let fromNumber = data["from-#"]! as! String
            let contactName = Database.sharedInstance.contactTable.getContact(fromNumber)?.getName()
            if (contactName != nil) {
                localNotification.alertBody = contactName! + Language.atRequest
            } else {
                // TODO: We probably don't want to accept requests from arbitrary numbers
                localNotification.alertBody = fromNumber + Language.atRequest
            }
            localNotification.fireDate = NSDate()
            localNotification.category = "REQUEST_LOCATION_CATEGORY";
        } else if (self.requestType == RequestType.AtResponse) {
            let fromNumber = data["from-#"]! as! String
            let contactName = Database.sharedInstance.contactTable.getContact(fromNumber)?.getName()
            let place = data["place"]! as! String
            if (contactName != nil) {
                localNotification.alertBody = contactName! + Language.atResponse + place
            } else {
                // TODO: We probably don't want to accept requests from arbitrary numbers
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
    func constructAlertNotification() -> UIAlertController {
        let alertController = UIAlertController()

        if (self.requestType == RequestType.AtRequest) {
            let fromNumber = data["from-#"]! as! String
            let contactName = Database.sharedInstance.contactTable.getContact(fromNumber)?.getName()
            if (contactName != nil) {
                alertController.message = contactName! + Language.atRequest
            } else {
                alertController.message = fromNumber + Language.atRequest
            }
            alertController.addAction(UIAlertAction(title: "Ignore", style: UIAlertActionStyle.Default, handler: nil))
            alertController.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                let number = self.data["from-#"]! as! String
                self.locManager.sendLocation(number)
            }))
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
                UIApplication.sharedApplication().scheduleLocalNotification(self.notification!)
            } else {
                self.viewController!.presentViewController(self.alert!, animated: true, completion: nil)
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