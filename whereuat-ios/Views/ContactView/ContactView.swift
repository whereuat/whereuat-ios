//
//  ContactView.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 2/11/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit
import Alamofire
import JLToast

/* 
 * ContactView is the parent view that contains the individual contact's information
 */
class ContactView: UIView {
    
    var delegate: ContactsViewController!
    
    var displayContactView: DisplayContactView!
    var editContactView: EditContactView!
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
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ContactView.contactCardFlip(_:)))
        longPress.minimumPressDuration = 0.25
        self.addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ContactView.requestLocationFromContact(_:)))
        self.addGestureRecognizer(tap)
        
        self.userInteractionEnabled = true
        self.addConstrainedSubview(displayContactView)
    }
    
    /*
     * contactCardFlip flips the displayContactView to the EditContactView by a flipping transition
     */
    func contactCardFlip(sender: UILongPressGestureRecognizer) {
        // TODO: This should be moved to a more sensible location, but it needs to happen
        // after initialization because of the order in which the contactViewCell is drawn
        self.displayContactView.delegate = self.delegate
        self.editContactView.delegate = self.delegate
        
        // Fetch the latest contact data
        self.contactData = Database.sharedInstance.contactTable.getContact((contactData?.phoneNumber)!)
        self.displayContactView.autoShareEnabled = contactData.autoShare
        self.editContactView.autoShareEnabled = contactData.autoShare
        self.editContactView.requestedCount = contactData.requestedCount
        
        // Return out of the function if we have ended the transition.
        // This prevents the animation from getting called twice during a long press.
        if (sender.state != UIGestureRecognizerState.Ended) {
            return
        }
        if (displayContactMode) {
            UIView.transitionFromView(displayContactView, toView: editContactView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil);
            displayContactMode = false
            self.addConstrainedSubview(editContactView)
            self.displayContactView.removeFromSuperview()
            self.editContactView.requestedCountView.removeFromSuperview()
            self.editContactView.drawRequestedCountTextView()
        } else {
            UIView.transitionFromView(editContactView, toView: displayContactView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            displayContactMode = true
            self.addConstrainedSubview(displayContactView)
            self.editContactView.removeFromSuperview()
            self.displayContactView.drawDisplayContactContent()
        }
    }
    
    /*
     * requestLocationFromContact performs an AtRequest to get the location of a given contact
     * TODO: Break up this logic into a smarter place
     */
    func requestLocationFromContact(sender: UITapGestureRecognizer) {
        // Fade the view out a little
        UIView.animateWithDuration(1.0) {
            self.alpha = 0.5
        }
        
        let whereRequestURL = Global.serverURL + "/where"
        let fromPhoneNumber = NSUserDefaults.standardUserDefaults().stringForKey("phoneNumber")!
        let toPhoneNumber = contactData.phoneNumber
        let verificationParameters = [
            "from" : fromPhoneNumber,
            "to" : toPhoneNumber,
        ]
        JLToast.makeText(Language.atRequestSending).show()
        Alamofire.request(.POST, whereRequestURL, parameters: verificationParameters, encoding: .JSON)
            .validate()
            .responseString { response in
                switch response.result {
                case .Success:
                    JLToast.makeText(Language.atRequestSent).show()
                    debugPrint(response)
                    print("Location requested:", toPhoneNumber)
                case .Failure(let error):
                    print(error)
                    JLToast.makeText(Language.atRequestFailed).show()
                    print("Failed to request location:", toPhoneNumber)
                }
        }
        // Propagate request to database layer: update request count number
        Database.sharedInstance.contactTable.updateRequestedCount(self.contactData.phoneNumber)
        
        // Fade the view back in
        UIView.animateWithDuration(1.0) {
            self.alpha = 1.0
        }
    }
    
    /*
     * addConstrainedSubview adds views to the contactView in a uniformly constrained manner
     */
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
