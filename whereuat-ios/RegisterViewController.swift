//
//  RegisterViewController.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 3/1/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, RegisterViewDelegate {
    
    var isAuthenticated = false
    var registerView: RegisterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerView = RegisterView()
        registerView.delegate = self
        view.addSubview(registerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goButtonClickHandler() {
        // HTTP: Send verification code through
        let verificationCode = self.registerView.verficationCodeView.text
        if (verificationCode == "11111") {
            isAuthenticated = true
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isRegistered")
        }
        if (isAuthenticated) {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let contactsViewController = storyBoard.instantiateViewControllerWithIdentifier("ContactsViewController") as! ContactsViewController
            
            self.presentViewController(contactsViewController, animated: true, completion: nil)
        } else {
            registerView.askForAuthentication();
        }
    }

}