//
//  AppDelegate.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 2/8/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit
import CoreLocation

let themeColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GGLInstanceIDDelegate, GCMReceiverDelegate {

    var window: UIWindow?
    var contactTable = Database.sharedInstance.contactTable
    
    // GCM Variables
    var connectedToGCM = false
    var subscribedToTopic = false
    var gcmSenderID: String?
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    let registrationKey = "onRegistrationCompleted"
    let messageKey = "onMessageReceived"
    let subscriptionTopic = "/topics/global"


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // Configure push notifications
        let request_location_category = getRequestLocationNotificationCategory()
        let receive_location_category = getReceiveLocationNotificationCategory()
        let pushNotificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: [request_location_category, receive_location_category])
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
        // Set up GCM
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        let gcmConfig = GCMConfig.defaultConfig()
        gcmConfig.receiverDelegate = self
        GCMService.sharedInstance().startWithConfig(gcmConfig)

        print("App is launching")
        
        // Override point for customization after application launch.
        window?.tintColor = themeColor
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let isRegistered = NSUserDefaults.standardUserDefaults().boolForKey("isRegistered")
        var initialViewController: UIViewController
        
        // Check if we are registered already. If so, instantiate ContactsViewController. Otherwise present RegisterViewController
        if (isRegistered) {
            initialViewController = storyBoard.instantiateViewControllerWithIdentifier("ContactsViewController") as! ContactsViewController
        } else {
            initialViewController = storyBoard.instantiateViewControllerWithIdentifier("RegisterViewController") as! RegisterViewController
            self.contactTable.dropTable()
            // Create database tables
            self.contactTable.setUpTable()
            // Load mock data into database
            self.contactTable.generateMockData()
        }
        
        // Set up the initial view controller
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

        return true
    }
    
    func getRequestLocationNotificationCategory() -> UIMutableUserNotificationCategory {
        let ignoreAction = UIMutableUserNotificationAction()
        ignoreAction.identifier = "IGNORE_IDENTIFIER"
        ignoreAction.title = "Ignore"
        ignoreAction.activationMode = .Foreground
        let sendAction = UIMutableUserNotificationAction()
        sendAction.identifier = "SEND_IDENTIFIER"
        sendAction.title = "Send"
        sendAction.activationMode = .Foreground
        
        let request_location_category = UIMutableUserNotificationCategory()
        request_location_category.identifier = "REQUEST_LOCATION_CATEGORY"
        request_location_category.setActions([ignoreAction, sendAction], forContext: .Default)
        
        return request_location_category
    }
    
    func getReceiveLocationNotificationCategory() -> UIMutableUserNotificationCategory {
        let doneAction = UIMutableUserNotificationAction()
        doneAction.identifier = "DONE_IDENTIFIER"
        doneAction.title = "Done"
        doneAction.activationMode = .Foreground
        
        let received_location_category = UIMutableUserNotificationCategory()
        received_location_category.identifier = "RECEIVE_LOCATION_CATEGORY"
        received_location_category.setActions([doneAction], forContext: .Default)
        
        return received_location_category
    }
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: NSData ) {
            // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
            let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
            instanceIDConfig.delegate = self
            // Start the GGLInstanceID shared instance with that config and request a registration
            // token to enable reception of notifications
            GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
            registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken,
                kGGLInstanceIDAPNSServerTypeSandboxOption:true]
            GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
                scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError ) {
            print("Registration for remote notification failed with error: \(error.localizedDescription)")
            // [END receive_apns_token_error]
            let userInfo = ["error": error.localizedDescription]
            NSNotificationCenter.defaultCenter().postNotificationName(
                registrationKey, object: nil, userInfo: userInfo)
    }
    
    // This method is invoked when a notification is received.
    // If the application is in the foreground, it is received as an alert
    // If the application is in the background, it is received as a push notification
    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
        GCMService.sharedInstance().appDidReceiveMessage(userInfo)
        if application.applicationState == .Background {
            let notification = Notification(data: userInfo, notificationType: NotificationType.PushNotification)
            notification.fire()
        }
        else {
            let notification = Notification(data: userInfo, notificationType: NotificationType.Alert)
            notification.fire()
        }
        handler(UIBackgroundFetchResult.NoData);
    }
    
    func registrationHandler(registrationToken: String!, error: NSError!) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken
            print("Registration Token: \(registrationToken)")
            self.subscribeToTopic()
            let userInfo = ["registrationToken": registrationToken]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
            NSUserDefaults.standardUserDefaults().setObject(self.registrationToken, forKey: "gcmToken")
        } else {
            print("Registration to GCM failed with error: \(error.localizedDescription)")
            let userInfo = ["error": error.localizedDescription]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        }
    }
    
    func subscribeToTopic() {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        if(registrationToken != nil && connectedToGCM) {
            GCMPubSub.sharedInstance().subscribeWithToken(self.registrationToken, topic: subscriptionTopic,
                options: nil, handler: {(error:NSError?) -> Void in
                    if let error = error {
                        // Treat the "already subscribed" error more gently
                        if error.code == 3001 {
                            print("Already subscribed to \(self.subscriptionTopic)")
                        } else {
                            print("Subscription failed: \(error.localizedDescription)");
                        }
                    } else {
                        self.subscribedToTopic = true;
                        NSLog("Subscribed to \(self.subscriptionTopic)");
                    }
            })
        }
    }
    
    func applicationDidBecomeActive( application: UIApplication) {
        // Connect to the GCM server to receive non-APNS notifications
        GCMService.sharedInstance().connectWithHandler({(error:NSError?) -> Void in
            if let error = error {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                print("Connected to GCM")
                self.subscribeToTopic()
            }
        })
    }
    
    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        GCMService.sharedInstance().disconnect()
        // [START_EXCLUDE]
        self.connectedToGCM = false
        // [END_EXCLUDE]
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        print("here")
        if (identifier == "SEND_IDENTIFIER") {
            print(aps)
        }
        completionHandler()
    }
}

