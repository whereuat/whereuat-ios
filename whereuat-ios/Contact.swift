//
//  Contact.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 4/18/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import Foundation
import UIKit

// Contact stores relevant information for a contact
class Contact: Model {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var autoShare: Bool
    var requestedCount: Int
    var color: UIColor
    
    init(firstName: String, lastName: String, phoneNumber: String, autoShare: Bool, requestedCount: Int, color: UIColor) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.autoShare = autoShare
        self.requestedCount = requestedCount
        self.color = color
    }
    
    /*
     * getName gets a concatenated version of a contact's first and last names
     * @return - concatenated first and last name
     */
    func getName() -> String {
        return self.firstName + " " + self.lastName
    }
    
    /*
     * generateInitials gets the initials of a contact
     * @return - first letter of first and last names
     */
    func generateInitials() -> String {
        if (self.firstName.characters.count == 0 && self.lastName.characters.count == 0) {
            return "**"
        } else if (self.firstName.characters.count == 0) {
            return String(self.lastName[self.lastName.startIndex]).uppercaseString
        } else if (self.lastName.characters.count == 0) {
            return String(self.firstName[self.firstName.startIndex]).uppercaseString
        }
        return (String(self.firstName[self.firstName.startIndex])
            + String(self.lastName[self.lastName.startIndex])).uppercaseString
    }
}