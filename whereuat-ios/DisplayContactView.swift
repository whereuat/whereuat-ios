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
    var autoShareShapeView: UIView!

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
        drawAutoShareShapeView()
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
        self.fullnameView.backgroundColor = ColorWheel.transparent
        self.fullnameView.textColor = ColorWheel.lightGray
        self.fullnameView.font = FontStyle.p
        self.fullnameView.text = self.contactName
        
        // Disable interactions
        self.fullnameView.userInteractionEnabled = false
    }
    
    func generateInitials(fullname: String) -> String {
        return "JA"
        // TODO: Implement this function
        // such that we can extract JA from Julius Alexander
        // Julius Alexander IV --> JA
        // Raymond Jacobson --> RJ
        // Raymond Shu Jacobson --> RJ
        // Raymond --> R
        // Raymond Jacob Jingle Heimer Schmitt --> RS
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
        self.initialsView.backgroundColor = ColorWheel.transparent
        self.initialsView.textColor = ColorWheel.lightGray
        self.initialsView.font = FontStyle.h1
        self.initialsView.text = self.generateInitials(self.contactName)
        
        // Disable interactions
        self.initialsView.userInteractionEnabled = false
    }
    
    func drawAutoShareShapeView() {
        let starWidth = CGFloat(28)
        let starHeight = CGFloat(28)
        self.autoShareShapeView = UIView(frame: CGRect(x: 0, y:spacingMargin, width: starWidth, height: starHeight))
        
        self.autoShareShapeView.backgroundColor = UIColor.redColor()
        
        // Define sizing and positioning
        self.addSubview(self.autoShareShapeView)
        self.autoShareShapeView.translatesAutoresizingMaskIntoConstraints = false
        let rightConstraint = NSLayoutConstraint(item: self.autoShareShapeView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: -(starWidth + spacingMargin))
        let topConstraint = NSLayoutConstraint(item: self.autoShareShapeView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: spacingMargin)
        self.addConstraints([rightConstraint, topConstraint])

        // Draw a star!
        let width = self.autoShareShapeView.layer.frame.size.width
        let height = self.autoShareShapeView.layer.frame.size.height
        let shape = Shape.drawStar(self.bounds, width, height, ColorWheel.lightGray, ColorWheel.lightGray)
        
        self.autoShareShapeView.layer.insertSublayer(shape, atIndex: 0)
    }
    
}
