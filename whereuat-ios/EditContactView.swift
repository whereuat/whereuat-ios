//
//  DisplayContactView.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 2/18/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit

class EditContactView: UIView {
    
    var contactName: String!
    
    var nameView: UITextView!
    
    var autoShareView: UIView!
    var autoShareTextView: UITextView!
    var autoShareShapeView: UIView!
    
    // To determine if auto-share enabled for this contact
    var autoShareEnabled = false
    
    var requestedCountView: UITextView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(contactName: String) {
        // Default initialize the size of the view.
        // The parent ContactView controls the constraint sizing of this view during animation
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        self.backgroundColor = ColorWheel.lightGray
        self.contactName = contactName
        
        self.drawEditContactContent()
    }
    
    func drawEditContactContent() {
        drawNameTextView()
        drawAutoShareView()
        drawRequestedCountTextView()
    }
    
    func drawNameTextView() {
        self.nameView = UITextView()
        
        // Define sizing and positioning
        self.nameView.scrollEnabled = false // Scroll disabled to allow constraints
        self.addSubview(self.nameView)
        self.nameView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self.nameView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.nameView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 1.5*SizingConstants.spacingMargin)
        self.addConstraints([widthConstraint, topConstraint])
        
        // Define contents
        self.nameView.textAlignment = NSTextAlignment.Center
        self.nameView.backgroundColor = ColorWheel.transparent
        self.nameView.textColor = ColorWheel.darkGray
        self.nameView.font = FontStyle.h5
        self.nameView.text = self.contactName
        
        // Disable interactions
        self.nameView.userInteractionEnabled = false
    }
    
    func drawAutoShareView() {
        self.autoShareView = UIView()
        
        // Define sizing and positioning
        self.addSubview(self.autoShareView)
        self.autoShareView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self.autoShareView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let centerXConstraint = NSLayoutConstraint(item: self.autoShareView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: self.autoShareView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: -SizingConstants.spacingMargin)
        self.addConstraints([widthConstraint, centerXConstraint, centerYConstraint])
        
        // Draw children
        drawAutoShareTextView()
        drawAutoShareShapeView()
    }
    
    func drawAutoShareTextView() {
        self.autoShareTextView = UITextView()
        
        // Define sizing and positioning
        self.autoShareTextView.scrollEnabled = false // Scroll disabled to allow constraints
        self.autoShareView.addSubview(self.autoShareTextView)
        self.autoShareTextView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: self.autoShareTextView, attribute: .Height, relatedBy: .Equal, toItem: self.autoShareView, attribute: .Height, multiplier: 1.0, constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: self.autoShareTextView, attribute: .Width, relatedBy: .Equal, toItem: self.autoShareView, attribute: .Width, multiplier: 0.67, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.autoShareTextView, attribute: .Top, relatedBy: .Equal, toItem: self.autoShareView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let leftConstraint = NSLayoutConstraint(item: self.autoShareTextView, attribute: .Left, relatedBy: .Equal, toItem: self.autoShareView, attribute: .Left, multiplier: 1.0, constant: 0.0)
        self.addConstraints([heightConstraint, widthConstraint, topConstraint, leftConstraint])
        
        // Define contents
        self.autoShareTextView.backgroundColor = ColorWheel.transparent
        self.autoShareTextView.textColor = ColorWheel.darkGray
        self.autoShareTextView.font = FontStyle.p
        self.autoShareTextView.text = "Auto Share?" // TODO put this in a constant somewhere
        self.autoShareTextView.textAlignment = NSTextAlignment.Right
        
        // Disable interactions
        self.autoShareTextView.userInteractionEnabled = false
    }
    
    func drawAutoShareShapeView() {
        self.autoShareShapeView = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        
        // Define sizing and positioning
        self.autoShareView.addSubview(self.autoShareShapeView)
        self.autoShareShapeView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self.autoShareShapeView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0.33, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.autoShareShapeView, attribute: .Top, relatedBy: .Equal, toItem: self.autoShareTextView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let leftConstraint = NSLayoutConstraint(item: self.autoShareShapeView, attribute: .Left, relatedBy: .Equal, toItem: self.autoShareTextView, attribute: .Right, multiplier: 1.0, constant: 0.0)
        self.addConstraints([widthConstraint, leftConstraint, topConstraint])
        
        // Draw a star!
        let width = self.autoShareShapeView.layer.frame.size.width
        let height = self.autoShareShapeView.layer.frame.size.height
        let shape = Shape.drawStar(self.bounds, width, height, ColorWheel.darkGray, ColorWheel.transparent)
        
        self.autoShareShapeView.layer.insertSublayer(shape, atIndex: 0)
        
        // Add gestures
        let tap = UITapGestureRecognizer(target: self, action: Selector("toggleAutoShare"))
        self.autoShareView.addGestureRecognizer(tap)
    }
    
    func toggleAutoShare() {
        var star = CAShapeLayer()
        star = self.autoShareShapeView.layer.sublayers![0] as! CAShapeLayer
        if (!autoShareEnabled) {
            star.fillColor = star.strokeColor
        } else {
            star.fillColor = ColorWheel.transparent.CGColor
        }
        autoShareEnabled = !autoShareEnabled
    }

    func drawRequestedCountTextView() {
        self.requestedCountView = UITextView()
        
        // Define sizing and positioning
        self.requestedCountView.scrollEnabled = false // Scroll disabled to allow constraints
        self.addSubview(self.requestedCountView)
        self.requestedCountView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self.requestedCountView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0.70, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.requestedCountView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -SizingConstants.spacingMargin)
        let centerXConstraint = NSLayoutConstraint(item: self.requestedCountView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        self.addConstraints([widthConstraint, bottomConstraint, centerXConstraint])
        
        // Define contents
        self.requestedCountView.textAlignment = NSTextAlignment.Center
        self.requestedCountView.backgroundColor = ColorWheel.transparent
        self.requestedCountView.textColor = ColorWheel.darkGray
        self.requestedCountView.font = FontStyle.p
        self.requestedCountView.text = "Requested 5002 times"
        
        // Disable interactions
        self.requestedCountView.userInteractionEnabled = false

    }

}
