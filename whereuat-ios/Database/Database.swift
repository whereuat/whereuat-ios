//
//  Database.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 4/14/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import Foundation

/* 
 * Database maintains the SQLite database instance for on-phone storage.
 * It is implemented as a singleton and during initialization, optionally auto drops the tables
 * and generates mock data if DEBUG mode is set
 */
class Database {
    static let sharedInstance = Database()
    
    var contactTable: ContactTable!
    var keyLocationTable: KeyLocationTable!
    var contactRequestTable: ContactRequestTable!
    
    init() {
        self.contactTable = ContactTable.sharedInstance
        self.keyLocationTable = KeyLocationTable.sharedInstance
        self.contactRequestTable = ContactRequestTable.sharedInstance
        
        initTable(self.contactTable)
        initTable(self.keyLocationTable)
        initTable(self.contactRequestTable)
    }
    
    /*
     * initTable initializes a table belonging to the database
     * @param table - the Table to be initialized
     */
    func initTable(table: Table) {
        #if DEBUG
            table.dropTable()
        #endif
        // Create database tables
        table.setUpTable()
        #if DEBUG
            // Load mock data into database
            table.generateMockData()
        #endif
    }
}