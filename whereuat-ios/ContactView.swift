//
//  ContactView.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 2/11/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit
import Alamofire

class ContactView: UIView {
    
    var displayContactView: DisplayContactView!
    var editContactView: UIView!
    var displayContactMode = true
    
    var contactColor: UIColor!
    var contactData: Contact!
    
    init(contactData: Contact) {
        // Initialize contact data from parent cell
        self.contactData = contactData
            
        // Initialize contactColor
        self.contactColor = ColorWheel.randomColor()
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize() {
        // Initialize views
        displayContactView = DisplayContactView(contactData: contactData)
        editContactView = EditContactView(contactData: contactData)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: Selector("contactCardFlip:"))
        longPress.minimumPressDuration = 0.25
        self.addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("requestLocationFromContact:"))
        self.addGestureRecognizer(tap)
        
        self.userInteractionEnabled = true
        self.addConstrainedSubview(displayContactView)
    }
    
    func contactCardFlip(sender: UILongPressGestureRecognizer) {
        if (sender.state != UIGestureRecognizerState.Ended) {
            return
        }
        if (displayContactMode) {
            UIView.transitionFromView(displayContactView, toView: editContactView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil);
            displayContactMode = false
            self.addConstrainedSubview(editContactView)
        } else {
            UIView.transitionFromView(editContactView, toView: displayContactView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            displayContactMode = true
            self.addConstrainedSubview(displayContactView)
        }
    }
    
    func requestLocationFromContact(sender: UITapGestureRecognizer) {
        let fromPhoneNumber = NSUserDefaults.standardUserDefaults().stringForKey("phoneNumber")!
        let toPhoneNumber = contactData.phoneNumber
        let verificationParameters = [
            "from" : fromPhoneNumber,
            "to" : toPhoneNumber,
        ]
        Alamofire.request(.POST, "http://whereuat.xyz/where", parameters: verificationParameters, encoding: .JSON)
            .validate()
            .responseString { response in
                switch response.result {
                case .Success:
                    debugPrint(response)
                    print("Location requested:", toPhoneNumber)
                case .Failure(let error):
                    print(error)
                    print("Failed to request location:", toPhoneNumber)
                }
        }
    }
    
    func addConstrainedSubview(viewName: UIView) {
        // Constrain the size of a view so that it conforms to self's size (constrained to screen-size adjusted ContactCell)
        self.addSubview(viewName)
        
        viewName.translatesAutoresizingMaskIntoConstraints = false
        let leftSideConstraint = NSLayoutConstraint(item: viewName, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: viewName, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: viewName, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: viewName, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: 0.0)
        self.addConstraints([leftSideConstraint, bottomConstraint, widthConstraint, heightConstraint])
    }

}
