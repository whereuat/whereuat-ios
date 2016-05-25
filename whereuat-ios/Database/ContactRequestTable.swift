//
//  ContactRequestTable.swift
//  whereuat
//
//  Created by Raymond Jacobson on 5/16/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation

import SQLite

/*
 * ContactRequestTable is the SQLite database tables for pending requests that have
 * not been added as contacts
 */
class ContactRequestTable: Table {
    static let sharedInstance = ContactRequestTable(databaseFilePath: "database.sqlite")
    
    private var databaseFilePath: String!
    
    var contactRequests: SQLite.Table
    var db: SQLite.Connection?
    var idColumn: SQLite.Expression<Int64>
    var firstNameColumn: SQLite.Expression<String>
    var lastNameColumn: SQLite.Expression<String>
    var phoneNumberColumn: SQLite.Expression<String>
    
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
        self.contactRequests = SQLite.Table("contactRequests")
        
        self.idColumn = SQLite.Expression<Int64>("id")
        self.firstNameColumn = SQLite.Expression<String>("firstName")
        self.lastNameColumn = SQLite.Expression<String>("lastName")
        self.phoneNumberColumn = SQLite.Expression<String>("phoneNumber")
    }
    
    /*
     * setUpTable instantiates the schema
     */
    func setUpTable() {
        do {
            try (self.db!).run(self.contactRequests.create(ifNotExists: true) { t in
                t.column(self.idColumn, primaryKey: true)
                t.column(self.firstNameColumn)
                t.column(self.lastNameColumn)
                t.column(self.phoneNumberColumn, unique: true)
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
            try (self.db)!.run(self.contactRequests.drop())
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
        let contact2 = Contact(firstName: "Yingjie",
                               lastName: "Shu",
                               phoneNumber: "+12029552443",
                               autoShare: false,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        let contact3 = Contact(firstName: "",
                               lastName: "",
                               phoneNumber: "+12077348728",
                               autoShare: false,
                               requestedCount: 0,
                               color: ColorWheel.randomColor())
        // Insert mock data
        insert(contact1)
        insert(contact2)
        insert(contact3)
    }
    
    /*
     * insert inserts a row into the database
     * @param - contact to insert
     */
    func insert(contact: Model) {
        let c = contact as! Contact
        let insert = self.contactRequests.insert(self.firstNameColumn <- c.firstName,
                                                 self.lastNameColumn <- c.lastName,
                                                 self.phoneNumberColumn <- c.phoneNumber)
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
        var contactRequestArray = Array<Contact>()
        do {
            for contact in (try (self.db!).prepare(self.contactRequests)) {
                contactRequestArray.append(Contact(firstName: contact[self.firstNameColumn],
                                                   lastName: contact[self.lastNameColumn],
                                                   phoneNumber: contact[self.phoneNumberColumn]))
            }
        } catch {
            print("Unable to get pending requests")
            return Array<Contact>()
        }
        return contactRequestArray
    }
    
    /*
     * dropContactRequest retrieves a particular pending request by phone number and removes
     * it from the table.
     * @param - phoneNumber is the phone number for the pending request lookup
     */
    func dropContactRequest(phoneNumber: String) {
        let query = contactRequests.filter(phoneNumberColumn == phoneNumber)
        do {
            try db!.run(query.delete())
        } catch {
            print("Unable to delete contactRequest")
        }
    }
    
    /*
     * getContactRequest retrives a particular pending request by phone number.
     * @param - phoneNumber is the phone number for the pending request lookup
     * @return the contact found
     */
    func getContactRequest(phoneNumber: String) -> Contact? {
        do {
            let query = contactRequests.filter(phoneNumberColumn == phoneNumber)
            let c = try (db!).prepare(query)
            for contact in  c {
                return Contact(firstName: contact[self.firstNameColumn],
                               lastName: contact[self.lastNameColumn],
                               phoneNumber: contact[self.phoneNumberColumn])
            }
            return nil
        } catch {
            print("Unable to get contact")
            return nil
        }
    }
}