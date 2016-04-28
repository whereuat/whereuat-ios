//
//  Table.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 4/14/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import Foundation

/* 
 * Table is a protocol implemented by SQLite database tables
 */
protocol Table {
    // This method should set a schema for a table
    func setUpTable()
    // This method should drop a table from a database
    func dropTable()
    // This method should generate relevant mock data for a table
    func generateMockData()
    // This method should take a model as an argument and insert it into the table
    func insert(obj: Model)
    // This method should be equivalent to a select * from SQL command
    func getAll() -> Array<Model>
}