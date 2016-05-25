//
//  Database.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 3/22/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import Foundation
import SQLite

/*
 * ContactTable is the SQLite database tables for contacts
 */
class ContactTable: Table {
    static let sharedInstance = ContactTable(databaseFilePath: "database.sqlite")
    
    private var databaseFilePath: String!
    
    var contacts: SQLite.Table
    var db: SQLite.Connection?
    var idColumn: SQLite.Expression<Int64>
    var firstNameColumn: SQLite.Expression<String>
    var lastNameColumn: SQLite.Expression<String>
    var phoneNumberColumn: SQLite.Expression<String>
    var autoShareColumn: SQLite.Expression<Bool>
    var requestedCountColumn: SQLite.Expression<Int>
    var colorColumn: SQLite.Expression<NSData> // Color is stored as NSData of a UIColor object
  
    /*
     * Init sets up the SQLite connection and constructs the schema
     */
    init(databaseFilePath: String) {
        self.databaseFilePath = databaseFilePath
        
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
        self.colorColumn = SQLite.Expression<NSData>("color")
    }

    /*
     * setUpTable instantiates the schema
     */
    func setUpTable() {
        do {
            try (self.db!).run(self.contacts.create(ifNotExists: true) { t in
                t.column(self.idColumn, primaryKey: true)
                t.column(self.firstNameColumn)
                t.column(self.lastNameColumn)
                t.column(self.phoneNumberColumn, unique: true)
                t.column(self.autoShareColumn, defaultValue: false)
                t.column(self.requestedCountColumn, defaultValue: 0)
                t.column(self.colorColumn)
            })
        } catch {
            print("Unable to set up Database")
        }
    }
    
    /*
     * dropTable drops the database table
     */
    func dropTable() {
        // Clean the database
        do {
            try (self.db)!.run(self.contacts.drop())
        } catch {
            print ("Unable to drop the database")
        }
    }
    
    /*
     * generateMockData fills the table with 5 mock contacts
     */
    func generateMockData() {
        let contact1 = Contact(firstName: "Damian",
                               lastName: "Mastylo",
                               phoneNumber: "+19133700735",
                               autoShare: true,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        let contact2 = Contact(firstName: "Raymond",
                               lastName: "Jacobson",
                               phoneNumber: "+13014672873",
                               autoShare: false,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        let contact3 = Contact(firstName: "Anders",
                               lastName: "Jepson",
                               phoneNumber: "+12077308728",
                               autoShare: false,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        let contact4 = Contact(firstName: "Peyton",
                               lastName: "Manning",
                               phoneNumber: "+12073308728",
                               autoShare: false,
                               requestedCount: 20,
                               color: ColorWheel.randomColor())
        let contact5 = Contact(firstName: "Dante",
                               lastName: "Inferno",
                               phoneNumber: "+12075308728",
                               autoShare: false,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        let contact6 = Contact(firstName: "Damian",
                               lastName: "Mastylo",
                               phoneNumber: "+19133700731",
                               autoShare: true,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        let contact7 = Contact(firstName: "Raymond",
                               lastName: "Jacobson",
                               phoneNumber: "+13014672871",
                               autoShare: false,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        let contact8 = Contact(firstName: "Anders",
                               lastName: "Jepson",
                               phoneNumber: "+12077308721",
                               autoShare: false,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        let contact9 = Contact(firstName: "Peyton",
                               lastName: "Manning",
                               phoneNumber: "+12073308721",
                               autoShare: false,
                               requestedCount: 20,
                               color: ColorWheel.randomColor())
        let contact10 = Contact(firstName: "Dante",
                               lastName: "Inferno",
                               phoneNumber: "+12075308721",
                               autoShare: false,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        let contact11 = Contact(firstName: "Damian",
                               lastName: "Mastylo",
                               phoneNumber: "+19133700732",
                               autoShare: true,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        let contact12 = Contact(firstName: "Raymond",
                               lastName: "Jacobson",
                               phoneNumber: "+13014672872",
                               autoShare: false,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        let contact13 = Contact(firstName: "Anders",
                               lastName: "Jepson",
                               phoneNumber: "+12077308722",
                               autoShare: false,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        let contact14 = Contact(firstName: "Peyton",
                               lastName: "Manning",
                               phoneNumber: "+12073308722",
                               autoShare: false,
                               requestedCount: 20,
                               color: ColorWheel.randomColor())
        let contact15 = Contact(firstName: "Dante",
                                lastName: "Inferno",
                                phoneNumber: "+12075308722",
                                autoShare: false,
                                requestedCount: 0,
                                color: ColorWheel.randomColor())
        // Insert mock data
        insert(contact1)
        insert(contact2)
        insert(contact3)
        insert(contact4)
        insert(contact5)
        insert(contact6)
        insert(contact7)
        insert(contact8)
        insert(contact9)
        insert(contact10)
        insert(contact11)
        insert(contact12)
        insert(contact13)
        insert(contact14)
        insert(contact15)
    }
    
    /*
     * insert inserts a row into the database
     * @param - contact to insert
     */
    func insert(contact: Model) {
        let c = contact as! Contact
        let insert = self.contacts.insert(self.firstNameColumn <- c.firstName,
                                          self.lastNameColumn <- c.lastName,
                                          self.phoneNumberColumn <- c.phoneNumber,
                                          self.autoShareColumn <- c.autoShare,
                                          self.colorColumn <- NSKeyedArchiver.archivedDataWithRootObject(c.color))
        do {
            try (self.db!).run(insert)
        } catch {
            print("Unable to insert contact")
        }
    }
    
    /*
     * getAll returns all of the rows in the table, a SELECT * FROM
     * @return - Array of Model type
     */
    func getAll() -> Array<Model> {
        var contactArray = Array<Contact>()
        do {
            for contact in (try (self.db!).prepare(self.contacts)) {
                contactArray.append(Contact(firstName: contact[self.firstNameColumn],
                                            lastName: contact[self.lastNameColumn],
                                            phoneNumber: contact[self.phoneNumberColumn],
                                            autoShare: contact[self.autoShareColumn],
                                            requestedCount: contact[self.requestedCountColumn],
                                            color: NSKeyedUnarchiver.unarchiveObjectWithData(contact[self.colorColumn]) as! UIColor))
            }
        } catch {
            print("Unable to get contacts")
            return Array<Contact>()
        }
        return contactArray
    }
    
    /*
     * getContact retrives a particular contact by phone number, a SELECT * FROM WHERE phoneNumber =
     * @param - phoneNumber is the phone number for the contact lookup
     * @return - Contact model that is found
     */
    func getContact(phoneNumber: String) -> Contact? {
        do {
            let query = contacts.filter(phoneNumberColumn == phoneNumber)
            let c = try (db!).prepare(query)
            for contact in  c {
                return Contact(firstName: contact[self.firstNameColumn],
                               lastName: contact[self.lastNameColumn],
                               phoneNumber: contact[self.phoneNumberColumn],
                               autoShare: contact[self.autoShareColumn],
                               requestedCount: contact[self.requestedCountColumn],
                               color: NSKeyedUnarchiver.unarchiveObjectWithData(contact[self.colorColumn]) as! UIColor)
            }
            return nil
        } catch {
            print("Unable to get contact")
            return nil
        }
    }
    
    /*
     * toggleAutoShare toggles the auto sharing capacity of a contact in the database
     * @param - phoneNumber is the phone number of the contact to update
     */
    func toggleAutoShare(phoneNumber: String) {
        let contact = getContact(phoneNumber)!
        let query = contacts.filter(phoneNumberColumn == phoneNumber)
        do {
            if (contact.autoShare == true) {
                try db!.run(query.update(self.autoShareColumn <- false))
            } else {
                try db!.run(query.update(self.autoShareColumn <- true))
            }
        } catch {
            print("Unable to update contact")
        }
    }
    
    /*
     * updateRequestedCount updates the number of times a contact has been requested, stored
     * in the database
     * @param - phoneNumber is the phone number of the contact to update
     */
    func updateRequestedCount(phoneNumber: String) {
        let contact = getContact(phoneNumber)!
        let query = contacts.filter(phoneNumberColumn == phoneNumber)
        do {
            try db!.run(query.update(self.requestedCountColumn <- contact.requestedCount + 1))
        } catch {
            print("Unable to update contact")
        }
    }
    
}