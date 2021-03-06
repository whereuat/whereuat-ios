//
//  RegisterViewController.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 3/1/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit
import Alamofire
import SlideMenuControllerSwift

class RegisterViewController: UIViewController, RegisterViewDelegate, UITextFieldDelegate {
    
    var verificationRequested = false
    var registerView: RegisterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.registerView = RegisterView()
        self.registerView.delegate = self
        
        view.addSubview(self.registerView)
        registerForKeyboardNotifications()
        
        self.registerView.areaCodeView.delegate = self
        self.registerView.lineNumberView.delegate = self
        self.registerView.verificationCodeView.delegate = self
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillBeShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
    
    /*
     * goButtonClickHandler handles clicks on the registration view.
     * since the same button is used for submitting phone number as well as submitting verification code,
     * there are two code paths to take.
     */
    func goButtonClickHandler() {
        // Fade the button out and disable it
        UIView.animateWithDuration(1.0) {
            self.registerView.goButton.alpha = 0.3
            self.registerView.goButton.backgroundColor = ColorWheel.darkGray
            self.registerView.goButton.enabled = false
        }
        if (self.verificationRequested) {
            // We have sent a phone number to the server already and are now sending a verification code
            self.sendVerificationCode()
        } else {
            // We are submitting a phone number
            self.sendPhoneNumber()
        }
    }
    
    /*
     * sendVerificationCode sends a verification code to the server to get validated
     */
    func sendVerificationCode() {
        let verificationCode = String(self.registerView.verificationCodeView.text!)
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
                    
                    // Instantiate view controllers for main views
                    let contactsViewController = storyBoard.instantiateViewControllerWithIdentifier("ContactsViewController") as! ContactsViewController
                    let drawerViewController = storyBoard.instantiateViewControllerWithIdentifier("DrawerViewController") as! DrawerViewController
                    
                    // Instantiate navigation bar view, which wraps the contactsView
                    let nvc: UINavigationController = UINavigationController(rootViewController: contactsViewController)
                    drawerViewController.homeViewController = nvc
                    
                    // Instantiate the slide menu, which wraps the navigation controller
                    SlideMenuOptions.contentViewScale = 1.0
                    let controller = SlideMenuController(mainViewController: nvc, leftMenuViewController: drawerViewController)
                    
                    self.presentViewController(controller, animated: true, completion: nil)
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    self.verificationRequested = false;
                    self.registerView.changeToPhoneNumberUI()
                }
        }
    }
    
    /*
     * sendPhoneNumber sends a phone number to the server to request an account (via verification code)
     */
    func sendPhoneNumber() {
        let phoneNumber = "+1" + self.registerView.areaCodeView.text! + self.registerView.lineNumberView.text!
        let requestAuthParameters = [
            "phone-#": phoneNumber
        ]
        Alamofire.request(.POST, Global.serverURL + "/account/request", parameters: requestAuthParameters, encoding: .JSON)
            .responseString { response in
                debugPrint(response)
                switch response.result {
                case .Success(_):
                    NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey: "phoneNumber")
                    // The next time goButtonClickHandler() is invoked, we are going to be requesting a verification
                    self.verificationRequested = true;
                    self.registerView.changeToVerificationUI()
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    /*
     * Set max length of input fields
     */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var allowedLength: Int
        switch textField.tag {
        case RegisterView.areaCodeViewTag:
            allowedLength = Global.areaCodeLength
            if textField.text?.characters.count == allowedLength && string.characters.count != 0 {
                self.registerView.lineNumberView.becomeFirstResponder()
                allowedLength = Global.lineNumberLength
            }
        case RegisterView.lineNumberViewTag:
            allowedLength = Global.lineNumberLength
            if textField.text?.characters.count == 0 && string.characters.count == 0 && self.registerView.lineNumberView.text?.characters.count == 0 {
                self.registerView.areaCodeView.becomeFirstResponder()
                allowedLength = Global.areaCodeLength
            }
        case RegisterView.verificationCodeViewTag:
            allowedLength = Global.verificationCodeLength
        default:
            allowedLength = 255
        }
        if textField.text?.characters.count >= allowedLength && range.length == 0 {
            // Change not allowed
            return false
        }
        else {
            // Change allowed
            return true
        }
    }
}