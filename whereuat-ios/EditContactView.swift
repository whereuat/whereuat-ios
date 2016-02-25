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
    
    var requestedCountView: UITextView!
    
    let spacingMargin = CGFloat(10)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(contactName: String) {
        // Default initialize the size of the view.
        // The parent ContactView controls the constraint sizing of this view during animation
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        self.backgroundColor = UIColor(red: 248/255, green: 247/255, blue: 243/255, alpha: 1.0) // TODO: Replace all instances of this color with a global
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
        let topConstraint = NSLayoutConstraint(item: self.nameView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: spacingMargin)
        self.addConstraints([widthConstraint, topConstraint])
        
        // Define contents
        self.nameView.textAlignment = NSTextAlignment.Center
        self.nameView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.nameView.textColor = UIColor(red: 133/255, green: 133/255, blue: 133/255, alpha: 1.0)
        self.nameView.font = UIFont.boldSystemFontOfSize(18.0)
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
        let centerYConstraint = NSLayoutConstraint(item: self.autoShareView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: -spacingMargin)
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
        self.autoShareTextView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.autoShareTextView.textColor = UIColor(red: 133/255, green: 133/255, blue: 133/255, alpha: 1.0)
        self.autoShareTextView.font = UIFont(name: "Helvetica", size: 18.0)
        self.autoShareTextView.text = "Auto Share?" // TODO put this in a constant somewhere
        self.autoShareTextView.textAlignment = NSTextAlignment.Right
        
        // Disable interactions
        self.autoShareTextView.userInteractionEnabled = false
    }
    
    func drawAutoShareShapeView() {
        self.autoShareShapeView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        
        
        // Define sizing and positioning
        self.autoShareView.addSubview(self.autoShareShapeView)
        self.autoShareShapeView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: self.autoShareShapeView, attribute: .Height, relatedBy: .Equal, toItem: self.autoShareView, attribute: .Height, multiplier: 1.0, constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: self.autoShareShapeView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0.33, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.autoShareShapeView, attribute: .Top, relatedBy: .Equal, toItem: self.autoShareView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let leftConstraint = NSLayoutConstraint(item: self.autoShareShapeView, attribute: .Left, relatedBy: .Equal, toItem: self.autoShareTextView, attribute: .Right, multiplier: 1.0, constant: 0.0)
        self.addConstraints([heightConstraint, widthConstraint, topConstraint, leftConstraint])
        
        let mask = CAShapeLayer()
        mask.frame = self.autoShareShapeView.layer.bounds
        
        let width = self.autoShareShapeView.layer.frame.size.width
        let height = self.autoShareShapeView.layer.frame.size.height

        let path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, 0.5*width, 0.0*height) // TODO: Function
        CGPathAddLineToPoint(path, nil, 0.65*width, 0.36*height)
        CGPathAddLineToPoint(path, nil, 1.0*width, 0.39*height)
        CGPathAddLineToPoint(path, nil, 0.75*width, 0.65*height)
        CGPathAddLineToPoint(path, nil, 0.86*width, 1.0*height)
        CGPathAddLineToPoint(path, nil, 0.5*width, 0.82*height)
        CGPathAddLineToPoint(path, nil, 0.14*width, 1.0*height)
        CGPathAddLineToPoint(path, nil, 0.25*width, 0.65*height)
        CGPathAddLineToPoint(path, nil, 0.0*width, 0.39*height)
        CGPathAddLineToPoint(path, nil, 0.36*width, 0.36*height)
        CGPathAddLineToPoint(path, nil, 0.5*width, 0.0*height)
        
        mask.path = path
        
        self.autoShareShapeView.layer.mask = mask
        
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.path = path
        shape.lineWidth = 3.0
        shape.strokeColor = UIColor(red: 133/255, green: 133/255, blue: 133/255, alpha: 1.0).CGColor
        shape.fillColor = UIColor(red: 133/255, green: 133/255, blue: 133/255, alpha: 0.0).CGColor
        
        self.autoShareShapeView.layer.insertSublayer(shape, atIndex: 0)
    }

    func drawRequestedCountTextView() {
        self.requestedCountView = UITextView()
        
        // Define sizing and positioning
        self.requestedCountView.scrollEnabled = false // Scroll disabled to allow constraints
        self.addSubview(self.requestedCountView)
        self.requestedCountView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self.requestedCountView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0.75, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.requestedCountView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -spacingMargin)
        let centerXConstraint = NSLayoutConstraint(item: self.requestedCountView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        self.addConstraints([widthConstraint, bottomConstraint, centerXConstraint])
        
        // Define contents
        self.requestedCountView.textAlignment = NSTextAlignment.Center
        self.requestedCountView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.requestedCountView.textColor = UIColor(red: 133/255, green: 133/255, blue: 133/255, alpha: 1.0)
        self.requestedCountView.font = UIFont(name: "Helvetica", size: 18)
        self.requestedCountView.text = "Requested 5002 times"
        
        // Disable interactions
        self.requestedCountView.userInteractionEnabled = false

    }

}
