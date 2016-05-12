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

/*
 * RegisterView draws the UI elements inside the registration page
 */
class RegisterView: UIView {
    
    var delegate: RegisterViewDelegate!
    
    var logoView: UIImageView!
    var appNameView: UITextView!
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
        self.drawAppNameView()
        self.drawEnterTextView()
        self.drawPhoneNumberView()
        self.drawVerificationCodeView()
        self.drawGoButton()
        
        // Register keyboard dismiss
        let keyboardDismissTap = UITapGestureRecognizer(target: self, action: #selector(RegisterView.dismissKeyboard(_:)))
        self.addGestureRecognizer(keyboardDismissTap)
    }
    
    /*
     * dismissKeyboard dismisses the keyboard from the view
     */
    func dismissKeyboard(sender:UITapGestureRecognizer){
        self.endEditing(true)
    }
    
    /*
     * drawLogoView draws the whereu@ city logo at the top of the view
     */
    func drawLogoView() {
        let image = UIImage(named: UIFiles.homeLogo)
        self.logoView = UIImageView(image: image!)
        
        self.logoView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.addSubview(self.logoView)
        self.logoView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self.logoView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 2*SizingConstants.spacingMargin)
        let widthConstraint = NSLayoutConstraint(item: self.logoView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0)
        self.addConstraints([topConstraint, widthConstraint])
    }
    
    /*
     * drawAppNameView draws the whereu@ app name at the top of the view under the logo
     */
    func drawAppNameView() {
        self.appNameView = UITextView()
        self.appNameView.textContainer.lineFragmentPadding = 0;
        self.appNameView.textContainerInset = UIEdgeInsetsZero;
        self.appNameView.editable = false
        self.appNameView.userInteractionEnabled = false

        self.appNameView.backgroundColor = ColorWheel.transparent
        self.appNameView.textColor = ColorWheel.coolRed
        self.appNameView.font = FontStyle.appName
        self.appNameView.text = Language.appName
        self.appNameView.textAlignment = .Center

        self.addSubview(self.appNameView)
        self.appNameView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self.appNameView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.appNameView, attribute: .Top, relatedBy: .Equal, toItem: self.logoView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: self.appNameView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0.15, constant: 0.0)
        self.addConstraints([widthConstraint, topConstraint, heightConstraint])
    }
    
    /*
     * drawEnterTextView is the helper text to fill out the form.
     * It is drawn under the logo.
     */
    func drawEnterTextView() {
        self.enterTextView = UITextView()
        self.enterTextView.editable = false
        self.enterTextView.userInteractionEnabled = false
        
        self.enterTextView.backgroundColor = ColorWheel.transparent
        self.enterTextView.textColor = ColorWheel.coolRed
        self.enterTextView.font = FontStyle.small
        self.enterTextView.text = Language.enterPhoneNumber
        self.enterTextView.textAlignment = .Center
        
        self.addSubview(self.enterTextView)
        self.enterTextView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self.enterTextView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.enterTextView, attribute: .Top, relatedBy: .Equal, toItem: self.appNameView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: self.enterTextView, attribute: .Height, relatedBy: .Equal, toItem: self.appNameView, attribute: .Height, multiplier: 0.5, constant: 0.0)
        self.addConstraints([widthConstraint, topConstraint, heightConstraint])
    }
    
    /*
     * drawPhoneNumberView draws two child phone number views under the helper text
     */
    func drawPhoneNumberView() {
        self.phoneNumberView = UIView()
        
        self.addSubview(self.phoneNumberView)
        self.phoneNumberView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: self.phoneNumberView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0.7, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.phoneNumberView, attribute: .Top, relatedBy: .Equal, toItem: self.enterTextView, attribute: .Bottom, multiplier: 1.0, constant: SizingConstants.halfSpacingMargin)
        let heightConstraint = NSLayoutConstraint(item: self.phoneNumberView, attribute: .Height, relatedBy: .Equal, toItem: self.enterTextView, attribute: .Height, multiplier: 1.0, constant: 0.0)
        let centerXConstraint = NSLayoutConstraint(item: self.phoneNumberView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        self.addConstraints([widthConstraint, topConstraint, heightConstraint, centerXConstraint])
        
        self.drawAreaCodeView()
        self.drawLineNumberView()
    }
    
    /*
     * drawAreaCodeView draws the text box to write an area code in
     */
    func drawAreaCodeView() {
        self.areaCodeView = UITextField()
        
        self.areaCodeView.backgroundColor = ColorWheel.offWhite
        let placeholder = NSAttributedString(string: Language.defaultAreaCode, attributes: [NSForegroundColorAttributeName: ColorWheel.offBlack])
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
    
    /*
     * drawLineNumberView draws the text box to write a phone line number in
     */
    func drawLineNumberView() {
        self.lineNumberView = UITextField()
        
        self.lineNumberView.backgroundColor = ColorWheel.offWhite
        let placeholder = NSAttributedString(string: Language.defaultLineNumber, attributes: [NSForegroundColorAttributeName: ColorWheel.offBlack])
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
    
    /*
     * drawVerificationCodeView draws the verification code view in the same location as the
     * phoneNumberView
     */
    func drawVerificationCodeView() {
        self.verificationCodeView = UITextField()
        
        self.verificationCodeView.backgroundColor = ColorWheel.offWhite
        let placeholder = NSAttributedString(string: Language.defaultVerificationCode, attributes: [NSForegroundColorAttributeName: ColorWheel.offBlack])
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
    
    /*
     * drawGoButton draws the button that performs actions on the page
     */
    func drawGoButton() {
        self.goButton = UIButton()
        self.goButton.setTitle(Language.verifyPhoneNumber, forState: .Normal)
        self.goButton.setTitleColor(ColorWheel.lightGray, forState: .Normal)
        self.goButton.titleLabel!.font = FontStyle.h5
        
        self.goButton.backgroundColor = ColorWheel.coolRed
        
        self.addSubview(self.goButton)
        self.goButton.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = NSLayoutConstraint(item: self.goButton, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0.4, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: self.goButton, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0.1, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.goButton, attribute: .Top, relatedBy: .Equal, toItem: self.phoneNumberView, attribute: .Bottom, multiplier: 1.0, constant: 4*SizingConstants.spacingMargin)
        let centerXConstraint = NSLayoutConstraint(item: self.goButton, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        self.addConstraints([widthConstraint, heightConstraint, topConstraint, centerXConstraint])
        
        // delegate the button's action to the controller
        self.goButton.addTarget(self.delegate, action: Selector("goButtonClickHandler"), forControlEvents: .TouchUpInside)
    }
    
    /*
     * changeToVerificationUI transitions to the verification text area from the phone number
     * text area
     */
    func changeToVerificationUI() {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            self.lineNumberView.alpha = 0.0
            self.areaCodeView.alpha = 0.0
            self.verificationCodeView.alpha = 1.0
            self.enterTextView.text = Language.enterVerificationCode
            self.goButton.setTitle(Language.submitRegistrationCode, forState: .Normal)
            }, completion: { finished in
                self.lineNumberView.removeFromSuperview()
                self.areaCodeView.removeFromSuperview()
        })
    }
    
}
