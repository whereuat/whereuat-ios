//
//  RegisterViewController.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 3/1/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController, RegisterViewDelegate {
    
    var verificationRequested = false
    var registerView: RegisterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.registerView = RegisterView()
        self.registerView.delegate = self
        
        view.addSubview(self.registerView)
        registerForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillBeShown(aNotification: NSNotification) {
        let frame = (aNotification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        UIView.animateWithDuration(0.25, animations: {
            self.registerView.frame.origin.y = -(frame.height-20)
            }, completion: {
                (value: Bool) in
        })
    }
    
    func keyboardWillBeHidden(aNotification: NSNotification) {
        self.registerView.frame.origin.y = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goButtonClickHandler() {
        
        if (self.verificationRequested) {
            // If we have sent a phone number to the server already and are now sending a verification code
            let verificationCode = String(self.registerView.verificationCodeView.text!)
            print(verificationCode)
            let phoneNumber = NSUserDefaults.standardUserDefaults().stringForKey("phoneNumber")!
            let gcmToken = NSUserDefaults.standardUserDefaults().stringForKey("gcmToken")!
            let verificationParameters = [
                "phone-#" : phoneNumber,
                "gcm-token" : gcmToken,
                "verification-code" : verificationCode,
                "client-os" : "IOS"
            ]
            Alamofire.request(.POST, Global.serverURL + "/account/new", parameters: verificationParameters, encoding: .JSON)
                .validate()
                .responseString { response in
                    switch response.result {
                    case .Success:
                        debugPrint(response)
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isRegistered")
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let contactsViewController = storyBoard.instantiateViewControllerWithIdentifier("ContactsViewController") as! ContactsViewController
                        
                        self.presentViewController(contactsViewController, animated: true, completion: nil)
                    case .Failure(let error):
                        print(error)
                    }
                }
        } else {
            // If we are submitting a phone number
            let phoneNumber = "+1" + self.registerView.areaCodeView.text! + self.registerView.lineNumberView.text!
            let requestAuthParameters = [
                "phone-#": phoneNumber
            ]
            Alamofire.request(.POST, Global.serverURL + "/account/request", parameters: requestAuthParameters, encoding: .JSON)
                .responseString { response in
                    debugPrint(response)
                    NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey: "phoneNumber")
                    // The next time goButtonClickHandler() is invoked, we are going to be requesting a verificationr
                    self.verificationRequested = true;
                    self.registerView.changeToVerificationUI()
            }

        }
    }

}