//
//  Database.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 3/22/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import Foundation
import SQLite

// Models
class Contact {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var autoShare: Bool
    var requestedCount: Int
    
    init(firstName: String, lastName: String, phoneNumber: String, autoShare: Bool, requestedCount: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.autoShare = autoShare
        self.requestedCount = requestedCount
    }
    
    // This function gets a concatenated version of a contact's first and last names
    func getName() -> String {
        return self.firstName + " " + self.lastName
    }
    
    // This function returns the initials of a contact (first letter of first and last names)
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

// Database Layer
class ContactDatabase {
    static let sharedInstance = ContactDatabase()
    
    private var databaseFilePath = "database.sqlite"
    
    var contacts: SQLite.Table
    var db: SQLite.Connection?
    var idColumn: SQLite.Expression<Int64>
    var firstNameColumn: SQLite.Expression<String>
    var lastNameColumn: SQLite.Expression<String>
    var phoneNumberColumn: SQLite.Expression<String>
    var autoShareColumn: SQLite.Expression<Bool>
    var requestedCountColumn: SQLite.Expression<Int>
  
    init() {
        if let dirs: [NSString] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.AllDomainsMask, true) as [NSString] {
                let dir = dirs[0]
                self.databaseFilePath = dir.stringByAppendingPathComponent(self.databaseFilePath);
        }
        
        do {
            self.db = try SQLite.Connection(self.databaseFilePath)
        } catch {
            print("Unable to connect to the Database")
        }
        self.contacts = SQLite.Table("contacts")
        
        self.idColumn = SQLite.Expression<Int64>("id")
        self.firstNameColumn = SQLite.Expression<String>("firstName")
        self.lastNameColumn = SQLite.Expression<String>("lastName")
        self.phoneNumberColumn = SQLite.Expression<String>("phoneNumber")
        self.autoShareColumn = SQLite.Expression<Bool>("autoShare")
        self.requestedCountColumn = SQLite.Expression<Int>("requestedCount")
    }

    func setUpDatabase() {

        do {
            try (self.db!).run(self.contacts.create(ifNotExists: true) { t in
                t.column(self.idColumn, primaryKey: true)
                t.column(self.firstNameColumn)
                t.column(self.lastNameColumn)
                t.column(self.phoneNumberColumn, unique: true)
                t.column(self.autoShareColumn, defaultValue: false)
                t.column(self.requestedCountColumn, defaultValue: 0)
            })
        } catch {
            print("Unable to set up Database")
        }
    }
    
    func dropDatabase() {
        // Clean the database
        do {
            try (self.db)!.run(self.contacts.drop())
        } catch {
            print ("Unable to drop the database")
        }
    }
    
    func generateMockData() {
        // Insert mock data
        do {
            try((self.db!).run(self.contacts.insert(self.firstNameColumn <- "Damian", self.lastNameColumn <- "Mastylo", self.phoneNumberColumn <- "+19133700735")))
            try((self.db!).run(self.contacts.insert(self.firstNameColumn <- "Raymond", self.lastNameColumn <- "Jacobson", self.phoneNumberColumn <- "+13014672873")))
            try((self.db!).run(self.contacts.insert(self.firstNameColumn <- "Anders", self.lastNameColumn <- "Jepson", self.phoneNumberColumn <- "+12077308728")))
        } catch {
            print("Unable to insert mock data")
        }
    }
    
    func insertContact(contact: Contact) {
        let insert = self.contacts.insert(self.firstNameColumn <- contact.firstName,
                                          self.lastNameColumn <- contact.lastName,
                                          self.phoneNumberColumn <- contact.phoneNumber)
        do {
            try (self.db!).run(insert)
        } catch {
            print("Unable to insert contact")
        }
    }
    
    func getContacts() -> Array<Contact> {
        var contactArray = Array<Contact>()
        do {
            for contact in (try (self.db!).prepare(self.contacts)) {
                contactArray.append(Contact(firstName: contact[self.firstNameColumn],
                                            lastName: contact[self.lastNameColumn],
                                            phoneNumber: contact[self.phoneNumberColumn],
                                            autoShare: contact[self.autoShareColumn],
                                            requestedCount: contact[self.requestedCountColumn]))
            }
        } catch {
            print("Unable to get contacts")
            return Array<Contact>()
        }
        return contactArray
    }
    
    func getContact(id: Int64) {
    }
    
    func toggleAutoShare(name: String) {
        
    }
    
    func updateRequestedCount(name: String) {
        
    }
    
}