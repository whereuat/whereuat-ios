//
//  ContactView.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 2/11/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit

class ContactView: UIView {
    
    var displayContactView: DisplayContactView!
    var editContactView: UIView!
    var displayContactMode = true
    
    var contactColor: UIColor!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        // Initialize views
        displayContactView = DisplayContactView(color: self.randomColor(), contactName: "Raymond Jacobson")
        editContactView = EditContactView(contactName: "Raymond Jacobson") // TODO: Make this stored and dynamic!
        
        let longPress = UILongPressGestureRecognizer(target: self, action: Selector("contactCardFlip:"))
        longPress.minimumPressDuration = 0.25
        self.addGestureRecognizer(longPress)
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
            self.addSubview(displayContactView)
            UIView.transitionFromView(editContactView, toView: displayContactView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            displayContactMode = true
            self.addConstrainedSubview(displayContactView)
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
    
    func randomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }

}
