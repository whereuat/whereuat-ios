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
    
    // Alert context
    static let setKeyLocation = "Okay"
    static let cancelKeyLocation = "Cancel"
    static let contactFirstName = "First name"
    static let contactLastName = "Last name"
    
    // Contact Requests context
    static let contactAdded = "Contact added!"
    static let openContactRequests = "Open Contact Requests"
}

/*
 * Icons is a list of global icons constant
 */
struct Icons {
    static let delete = "ic_cancel"
    static let edit = "ic_mode_edit"
    static let contactAdd = "ic_person_add"
    static let home = "ic_home"
    static let keyLocations = "ic_pin_drop"
    static let contactRequests = "ic_phone_missed"
    static let settings = "ic_settings"
}

/*
 * AppDrawer maintains global constants relevant to drawing the side navigation drawer
 */
struct AppDrawer {
    // App drawer context
    static let selfName = "Me"
    static let menuItems = [
        ["Home", Icons.home],
        ["Key Locations", Icons.keyLocations],
        ["Contact Requests", Icons.contactRequests],
        ["Settings", Icons.settings]
    ]
}

/*
 * UIFiles is a list of global constants that relate to images stored in XCAssets
 */
struct UIFiles {
    static let homeLogo = "home_logo"
    static let sideBarLogo = "side_bar_logo"
}