//
//  ContentPopup.swift
//  whereuat
//
//  Created by Raymond Jacobson on 5/16/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation

class ContentPopup {
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    static let database = Database.sharedInstance
    
    /*
     * addKeyLocation spawns an alert with a text view and adds the key location to the database
     */
    class func addKeyLocationAlert(refreshCallback: (() -> ())?=nil) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Set Current Location As", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
        })
        alert.addAction(UIAlertAction(title: Language.cancelKeyLocation, style: .Default, handler: { (action) -> Void in
        }))
        alert.addAction(UIAlertAction(title: Language.setKeyLocation, style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let loc = self.appDelegate.locManager.location
            let newKeyLocation = KeyLocation(name: textField.text!, longitude: loc.longitude, latitude: loc.latitude)
            self.database.keyLocationTable.insert(newKeyLocation)
            // Perform necessary callback on key location update
            if refreshCallback != nil {
                refreshCallback!()
            }
        }))
        return alert
    }
    
    /*
     * editKeyLocation spawns an alert with a text view and edits the provided key location to the database
     */
    class func editKeyLocationAlert(id: Int64, currentName: String, refreshCallback: (() -> ())?=nil) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Set Current Location As", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = currentName
        })
        alert.addAction(UIAlertAction(title: Language.cancelKeyLocation, style: .Default, handler: { (action) -> Void in
        }))
        alert.addAction(UIAlertAction(title: Language.setKeyLocation, style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            self.database.keyLocationTable.renameKeyLocation(id, newName: textField.text!)
            // Perform necessary callback on key location update
            if refreshCallback != nil {
                refreshCallback!()
            }
        }))
        return alert
    }
    
    /*
     * addContactWithNewNameAlert spawns an alert with two text views for a contact's first and last name
     * and adds the contact into the database with the first and last name.
     * It is used for adding pending request contacts to the database.
     */
    class func addContactWithNewNameAlert(phoneNumber: String, refreshCallback: (() -> ())?=nil) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Contact Name", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = Language.contactFirstName
            textField.tintColor = ColorWheel.darkGray
        })
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = Language.contactLastName
            textField.tintColor = ColorWheel.darkGray
        })
        alert.addAction(UIAlertAction(title: Language.cancelKeyLocation, style: .Default, handler: { (action) -> Void in
        }))
        alert.addAction(UIAlertAction(title: Language.setKeyLocation, style: .Default, handler: { (action) -> Void in
            let firstName = (alert.textFields![0] as UITextField).text!
            let lastName = (alert.textFields![1] as UITextField).text!
            self.database.contactRequestTable.dropContactRequest(phoneNumber)
            self.database.contactTable.insert(Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber))
            // Perform necessary refresh callback on contact update
            if refreshCallback != nil {
                refreshCallback!()
            }
        }))
        return alert
    }
}