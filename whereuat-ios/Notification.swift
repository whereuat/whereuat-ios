//
//  PushNotification.swift
//  whereuat
//
//  Created by Raymond Jacobson on 4/18/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation

enum NotificationType {
    case Alert
    case PushNotification
}

// A RequestType represents the two kinds of requests
enum RequestType {
    case AtRequest
    case AtResponse
    case UnknownRequest
}

class Notification {
    var viewController: UIViewController?
    var notificationType: NotificationType!
    var data: [NSObject : AnyObject]!
    var requestType: RequestType!
    var alert: UIAlertController?
    var notification: UILocalNotification?
    
    let locManager = LocationManager.sharedInstance
    
    // Initialize a notification. If the isAlert parameter is true, the notification is presented as an alert
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
    
    func constructPushNotification() -> UILocalNotification {
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.userInfo = self.data
        if (self.requestType == RequestType.AtRequest) {
            let fromNumber = data["from-#"]! as! String
            let contactName = Database.sharedInstance.contactTable.getContact(fromNumber)?.getName()
            localNotification.soundName = UILocalNotificationDefaultSoundName
            if (contactName != nil) {
                localNotification.alertBody = contactName! + Language.atRequest
            } else {
                localNotification.alertBody = fromNumber + Language.atRequest
            }
            localNotification.fireDate = NSDate()
            localNotification.category = "REQUEST_LOCATION_CATEGORY";
        } else if (self.requestType == RequestType.AtResponse) {
            let fromNumber = data["from-#"]! as! String
            let contactName = Database.sharedInstance.contactTable.getContact(fromNumber)?.getName()
            let place = data["place"]! as! String
            localNotification.soundName = UILocalNotificationDefaultSoundName
            if (contactName != nil) {
                localNotification.alertBody = contactName! + Language.atResponse + place
            } else {
                localNotification.alertBody = fromNumber + Language.atResponse + place
            }
            localNotification.fireDate = NSDate()
            localNotification.category = "RECEIVE_LOCATION_CATEGORY";
        }
        return localNotification
    }
    
    func constructAlertNotification() -> UIAlertController {
        var alertController = UIAlertController()
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
    
    // Fires the notification based on its notificationType
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
}