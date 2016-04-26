//
//  Database.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 4/14/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import Foundation

class Database {
    static let sharedInstance = Database()
    
    var contactTable: ContactTable!
    var keyLocationTable: KeyLocationTable!
    
    init() {
        self.contactTable = ContactTable.sharedInstance
        self.keyLocationTable = KeyLocationTable.sharedInstance
        
        initTable(self.contactTable)
        initTable(self.keyLocationTable)
    }
    
    func initTable(table: Table) {
        table.dropTable()
        // Create database tables
        table.setUpTable()
        #if DEBUG
            // Load mock data into database
            table.generateMockData()
        #endif
    }
}