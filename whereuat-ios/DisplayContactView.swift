//
//  DisplayContactView.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 2/18/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit

class DisplayContactView: UIView {
    
    var contactName: String!
    
    var initialsView: UITextView!
    var fullnameView: UITextView!
    
    let spacingMargin = CGFloat(10)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(color: UIColor, contactName: String) {
        // Default initialize the size of the view.
        // The parent ContactView controls the constraint sizing of this view during animation
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        self.backgroundColor = color
        self.contactName = contactName
        
        self.drawDisplayContactContent()
    }
    
    func drawDisplayContactContent() {
        drawInitialsTextView()
        drawFullnameTextView()
    }
    
    func drawFullnameTextView() {
        self.fullnameView = UITextView()
        
        // Define sizing and positioning
        self.fullnameView.scrollEnabled = false // Scroll disabled to allow constraints
        self.addSubview(self.fullnameView)
        self.fullnameView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self.fullnameView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.fullnameView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -spacingMargin)
        self.addConstraints([widthConstraint, bottomConstraint])

        // Define contents
        self.fullnameView.textAlignment = NSTextAlignment.Center
        self.fullnameView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.fullnameView.textColor = UIColor(red: 248/255, green: 247/255, blue: 243/255, alpha: 1.0)
        self.fullnameView.font = UIFont(name: "Helvetica", size: 18)
        self.fullnameView.text = self.contactName
        
        // Disable interactions
        self.fullnameView.userInteractionEnabled = false
    }
    
    func generateInitials(fullname: String) -> String {
        return "JA"
    }
    
    func drawInitialsTextView() {
        self.initialsView = UITextView()
        
        // Define sizing and positioning
        self.initialsView.scrollEnabled = false // Scroll disabled to allow constraints
        self.addSubview(self.initialsView)
        self.initialsView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self.initialsView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: self.initialsView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: -spacingMargin)
        self.addConstraints([widthConstraint, centerYConstraint])
        
        // Define contents
        self.initialsView.textAlignment = NSTextAlignment.Center
        self.initialsView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.initialsView.textColor = UIColor(red: 248/255, green: 247/255, blue: 243/255, alpha: 1.0)
        self.initialsView.font = UIFont(name: "Helvetica", size: 60)
        self.initialsView.text = self.generateInitials(self.contactName)
        
        // Disable interactions
        self.initialsView.userInteractionEnabled = false
    }
    
}
