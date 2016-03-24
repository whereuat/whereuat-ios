//
//  RegisterViewController.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 3/1/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, RegisterViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let registerView = RegisterView()
        registerView.delegate = self
        view.addSubview(registerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goButtonClickHandler() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let contactsViewController = storyBoard.instantiateViewControllerWithIdentifier("ContactsViewController") as! ContactsViewController
        
        self.presentViewController(contactsViewController, animated: true, completion: nil)
    }

}