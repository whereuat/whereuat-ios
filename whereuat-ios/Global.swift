//
//  Global.swift
//  whereuat
//
//  Created by Raymond Jacobson on 4/17/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation

/*
 * Global is a list of constants used by whereu@
 */
struct Global {
    static let serverURL = "http://whereuat.xyz"
}

/*
 * Language is a list of global constants representing language to be used throughout
 * application UX
 */
struct Language {
    static let appName = "whereu@"
    
    // Push notification context
    static let atRequest = ": whereu@?"
    static let atResponse = " is @ "
    static let atRequestSending = "Sending whereu@..."
    static let atRequestSent = "whereu@ sent!"
    static let atRequestFailed = "whereu@ failed :("
    
    // Registration context
    static let enterPhoneNumber = "please enter your phone number"
    static let enterVerificationCode = "enter the sms verification code"
    static let verifyPhoneNumber = "verify"
    static let submitRegistrationCode = "submit"
    static let defaultVerificationCode = "00000"
    static let defaultAreaCode = "XXX"
    static let defaultLineNumber = "XXXXXXX"
}

/*
 * AppDrawer maintains global constants relevant to drawing the side navigation drawer
 */
struct AppDrawer {
    // App drawer context
    static let selfName = "Me"
    static let menuItems = [
        ["Home", "ic_home"],
        ["Key Locations", "ic_pin_drop"],
        ["Pending Requests", "ic_phone_missed"],
        ["Settings", "ic_settings"]
    ]
}

/*
 * UIFiles is a list of global constants that relate to images stored in XCAssets
 */
struct UIFiles {
    static let homeLogo = "home_logo"
    static let sideBarLogo = "side_bar_logo"
}