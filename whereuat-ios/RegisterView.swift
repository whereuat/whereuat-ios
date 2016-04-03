//
//  RegisterView.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 3/1/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit
import Alamofire


protocol RegisterViewDelegate : class {
    func goButtonClickHandler()
}

class RegisterView: UIView {
    
    var delegate: RegisterViewDelegate!
    
    var logoView: UIImageView!
    var enterTextView: UITextView!
    var phoneNumberView: UIView!
    var areaCodeView: UITextField!
    var lineNumberView: UITextField!
    var verificationCodeView: UITextField!
    var goButton: UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        self.drawRegisterView()
    }
    
    func drawRegisterView() {
        self.backgroundColor = ColorWheel.lightGray
        self.drawLogoView()
        self.drawEnterTextView()
        self.drawPhoneNumberView()
        self.drawVerificationCodeView()
        self.drawGoButton()
    }
    
    func drawLogoView() {
        let imageName = "whereuat.png"
        let image = UIImage(named: imageName)
        self.logoView = UIImageView(image: image!)
        
        self.logoView.contentMode = UIViewContentMode.ScaleAspectFill

        let size = CGSizeApplyAffineTransform(image!.size, CGAffineTransformMakeScale(0.3, 0.3))

        self.logoView.frame = CGRect(origin: CGPoint(x: 0, y: 150), size: size)
        self.logoView.center.x = self.center.x
        self.addSubview(self.logoView)
    }
    
    func drawEnterTextView() {
        self.enterTextView = UITextView()
        
        self.enterTextView.backgroundColor = ColorWheel.transparent
        self.enterTextView.textColor = ColorWheel.coolRed
        self.enterTextView.font = FontStyle.small
        self.enterTextView.text = "please enter your phone number"
        self.enterTextView.textAlignment = .Center
        
        self.addSubview(self.enterTextView)
        self.enterTextView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self.enterTextView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.enterTextView, attribute: .Top, relatedBy: .Equal, toItem: self.logoView, attribute: .Bottom, multiplier: 1.0, constant: 4*SizingConstants.spacingMargin)
        let heightConstraint = NSLayoutConstraint(item: self.enterTextView, attribute: .Height, relatedBy: .Equal, toItem: self.logoView, attribute: .Height, multiplier: 0.5, constant: 0.0)
        self.addConstraints([widthConstraint, topConstraint, heightConstraint])
    }
    
    func drawPhoneNumberView() {
        self.phoneNumberView = UIView()
        
        self.addSubview(self.phoneNumberView)
        self.phoneNumberView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: self.phoneNumberView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0.7, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.phoneNumberView, attribute: .Top, relatedBy: .Equal, toItem: self.enterTextView, attribute: .Bottom, multiplier: 1.0, constant: SizingConstants.spacingMargin)
        let heightConstraint = NSLayoutConstraint(item: self.phoneNumberView, attribute: .Height, relatedBy: .Equal, toItem: self.enterTextView, attribute: .Height, multiplier: 1.0, constant: 0.0)
        let centerXConstraint = NSLayoutConstraint(item: self.phoneNumberView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        self.addConstraints([widthConstraint, topConstraint, heightConstraint, centerXConstraint])
        
        self.drawAreaCodeView()
        self.drawLineNumberView()
    }
    
    func drawAreaCodeView() {
        self.areaCodeView = UITextField()
        
        self.areaCodeView.backgroundColor = ColorWheel.offWhite
        let placeholder = NSAttributedString(string: "XXX", attributes: [NSForegroundColorAttributeName: ColorWheel.offBlack])
        self.areaCodeView.attributedPlaceholder = placeholder
        self.areaCodeView.font = FontStyle.smallLight
        self.areaCodeView.textColor = ColorWheel.offBlack
        self.areaCodeView.textAlignment = .Center
        self.areaCodeView.keyboardType = UIKeyboardType.NumberPad
        
        self.areaCodeView.layer.borderWidth = 1
        self.areaCodeView.layer.borderColor = ColorWheel.darkGray.CGColor
        
        self.addSubview(self.areaCodeView)
        self.areaCodeView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: self.areaCodeView, attribute: .Width, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Width, multiplier: 0.25, constant: 0.0)
        let leftConstraint = NSLayoutConstraint(item: self.areaCodeView, attribute: .Left, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.areaCodeView, attribute: .Top, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: self.areaCodeView, attribute: .Height, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Height, multiplier: 1.0, constant: 0.0)
        self.addConstraints([widthConstraint, topConstraint, heightConstraint, leftConstraint])
    }
    
    func drawVerificationCodeView() {
        self.verificationCodeView = UITextField()
        
        self.verificationCodeView.backgroundColor = ColorWheel.offWhite
        let placeholder = NSAttributedString(string: "12345", attributes: [NSForegroundColorAttributeName: ColorWheel.offBlack])
        self.verificationCodeView.attributedPlaceholder = placeholder
        self.verificationCodeView.font = FontStyle.smallLight
        self.verificationCodeView.textColor = ColorWheel.offBlack
        self.verificationCodeView.textAlignment = .Center
        self.verificationCodeView.keyboardType = UIKeyboardType.NumberPad
        
        self.verificationCodeView.layer.borderWidth = 1
        self.verificationCodeView.layer.borderColor = ColorWheel.darkGray.CGColor
        
        self.verificationCodeView.alpha = 0.0
        self.addSubview(self.verificationCodeView)
        self.verificationCodeView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: self.verificationCodeView, attribute: .Width, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Width, multiplier: 0.33, constant: 0.0)
        let centerXConstraint = NSLayoutConstraint(item: self.verificationCodeView, attribute: .CenterX, relatedBy: .Equal, toItem: self.enterTextView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.verificationCodeView, attribute: .Top, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: self.verificationCodeView, attribute: .Height, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Height, multiplier: 1.0, constant: 0.0)
        self.addConstraints([widthConstraint, topConstraint, heightConstraint, centerXConstraint])
    }
    
    func drawLineNumberView() {
        self.lineNumberView = UITextField()
        
        self.lineNumberView.backgroundColor = ColorWheel.offWhite
        let placeholder = NSAttributedString(string: "XXX - XXXX", attributes: [NSForegroundColorAttributeName: ColorWheel.offBlack])
        self.lineNumberView.attributedPlaceholder = placeholder
        self.lineNumberView.font = FontStyle.smallLight
        self.lineNumberView.textColor = ColorWheel.offBlack
        self.lineNumberView.textAlignment = .Center
        self.lineNumberView.keyboardType = UIKeyboardType.NumberPad
        
        self.lineNumberView.layer.borderWidth = 1
        self.lineNumberView.layer.borderColor = ColorWheel.darkGray.CGColor
        
        self.addSubview(self.lineNumberView)
        self.lineNumberView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: self.lineNumberView, attribute: .Width, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Width, multiplier: 0.65, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.lineNumberView, attribute: .Top, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: self.lineNumberView, attribute: .Height, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Height, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: self.lineNumberView, attribute: .Right, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Right, multiplier: 1.0, constant: 0.0)
        self.addConstraints([widthConstraint, topConstraint, heightConstraint, rightConstraint])
    }
    
    func drawGoButton() {
        self.goButton = UIButton()
        self.goButton.setTitle("send sms", forState: .Normal)
        self.goButton.setTitleColor(ColorWheel.lightGray, forState: .Normal)
        self.goButton.titleLabel!.font = FontStyle.h5
        self.goButton.backgroundColor = ColorWheel.coolRed
        
        self.addSubview(self.goButton)
        self.goButton.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = NSLayoutConstraint(item: self.goButton, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0.4, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.goButton, attribute: .Top, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Bottom, multiplier: 1.0, constant: 4*SizingConstants.spacingMargin)
        let heightConstraint = NSLayoutConstraint(item: self.goButton, attribute: .Height, relatedBy: .Equal, toItem: self.logoView, attribute: .Height, multiplier: 0.7, constant: 0.0)
        let centerXConstraint = NSLayoutConstraint(item: self.goButton, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        self.addConstraints([widthConstraint, topConstraint, heightConstraint, centerXConstraint])
        
        self.goButton.addTarget(self.delegate, action: "goButtonClickHandler", forControlEvents: .TouchUpInside)
    }
    
    func askForAuthentication() {
        let phone_parameters = [
            "phone-#": "+1" + self.areaCodeView.text! + self.lineNumberView.text!
        ]
        Alamofire.request(.POST, "http://whereuat.xyz/account/request", parameters: phone_parameters, encoding: .JSON)
                 .responseString { response in
                    debugPrint(response)
                    UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                            self.lineNumberView.alpha = 0.0
                            self.areaCodeView.alpha = 0.0
                            self.verificationCodeView.alpha = 1.0
                            self.enterTextView.text = "enter the sms verification code here"
                            self.goButton.setTitle("register", forState: .Normal)
                        }, completion: { finished in
                            self.lineNumberView.removeFromSuperview()
                            self.areaCodeView.removeFromSuperview()
                    })
        }
    }
    
}
