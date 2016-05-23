//
//  KeyLocationDatabase.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 4/14/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import Foundation
import SQLite

/*
 * KeyLocationTable is the SQLite database tables for key locations
 */
class KeyLocationTable: Table {
    static let sharedInstance = KeyLocationTable(databaseFilePath: "database.sqlite")
    
    private var databaseFilePath: String!
    
    var keyLocations: SQLite.Table
    var db: SQLite.Connection?
    var idColumn: SQLite.Expression<Int64>
    var nameColumn: SQLite.Expression<String>
    var longitudeColumn: SQLite.Expression<Double>
    var latitutdeColumn: SQLite.Expression<Double>
    
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
        self.keyLocations = SQLite.Table("key_locations")
        
        self.idColumn = SQLite.Expression<Int64>("id")
        self.nameColumn = SQLite.Expression<String>("name")
        self.longitudeColumn = SQLite.Expression<Double>("longitude")
        self.latitutdeColumn = SQLite.Expression<Double>("latitude")
    }
    
    /*
     * setUpTable initializes the schema
     */
    func setUpTable() {
        
        do {
            try (self.db!).run(self.keyLocations.create(ifNotExists: true) { t in
                t.column(self.idColumn, primaryKey: true)
                t.column(self.nameColumn)
                t.column(self.longitudeColumn)
                t.column(self.latitutdeColumn)
                })
        } catch {
            print("Unable to set up the table")
        }
    }
    
    /*
     * dropTable drops the database table
     */
    func dropTable() {
        // Clean the database
        do {
            try (self.db)!.run(self.keyLocations.drop())
        } catch {
            print ("Unable to drop the table")
        }
    }
    
    /*
     * generateMockData fills the table with 1 mock key location
     */
    func generateMockData() {
        // Insert mock data
        let keyLocation1 = KeyLocation(id: 1,
                                       name: "Home",
                                       longitude: -74.6901100,
                                       latitude: 42.7279760)
        let keyLocation2 = KeyLocation(id: 2,
                                       name: "Canta Rana",
                                       longitude: -74.6901105,
                                       latitude: 42.7279765)
        let keyLocation3 = KeyLocation(id: 3,
                                       name: "Peter's",
                                       longitude: -74.6901100,
                                       latitude: 42.7279760)
        let keyLocation4 = KeyLocation(id: 4,
                                       name: "Julius' Palace",
                                       longitude: -74.6901105,
                                       latitude: 42.7279765)
        let keyLocation5 = KeyLocation(id: 5,
                                       name: "Frisbee House",
                                       longitude: -74.6901100,
                                       latitude: 42.7279760)
        let keyLocation6 = KeyLocation(id: 6,
                                       name: "Non of your business",
                                       longitude: -74.6901105,
                                       latitude: 42.7279765)
        let keyLocation7 = KeyLocation(id: 7,
                                       name: "Anders' House",
                                       longitude: -74.6901100,
                                       latitude: 42.7279760)
        let keyLocation8 = KeyLocation(id: 8,
                                       name: "Workin' @ the Pyramid",
                                       longitude: -74.6901105,
                                       latitude: 42.7279765)
        insert(keyLocation1)
        insert(keyLocation2)
        insert(keyLocation3)
        insert(keyLocation4)
        insert(keyLocation5)
        insert(keyLocation6)
        insert(keyLocation7)
        insert(keyLocation8)
    }
    
    /* insert inserts a row into the database
     * @param - keyLocation to insert
     */
    func insert(keyLocation: Model) {
        let kL = keyLocation as! KeyLocation
        let insert = self.keyLocations.insert(self.nameColumn <- kL.name,
                                              self.longitudeColumn <- kL.longitude,
                                              self.latitutdeColumn <- kL.latitude)
        do {
            try (self.db!).run(insert)
        } catch {
            print("Unable to insert keyLocation")
        }
    }
    
    /*
     * getAll returns all of the rows in the table, a SELECT * FROM
     * @return - Array of Model type
     */
    func getAll() -> Array<Model> {
        var keyLocationArray = Array<KeyLocation>()
        do {
            for keyLocation in (try (self.db!).prepare(self.keyLocations)) {
                keyLocationArray.append(KeyLocation(id: keyLocation[self.idColumn],
                                                    name: keyLocation[self.nameColumn],
                                                    longitude: keyLocation[self.longitudeColumn],
                                                    latitude:  keyLocation[self.latitutdeColumn]))
            }
        } catch {
            print("Unable to get keyLocations")
            return Array<KeyLocation>()
        }
        return keyLocationArray
    }
    
    /*
     * renameKeyLocation retrieves a particular key location by id and renames it
     * @param - id is the id for the key location lookup
     */
    func renameKeyLocation(id: Int64, newName: String) {
        let query = keyLocations.filter(idColumn == id)
        do {
            try db!.run(query.update(self.nameColumn <- newName))
        } catch {
            print("Unable to update key location")
        }
    }
    
    /*
     * dropKeyLocation retrieves a particular key location by id and removes it from the table
     * @param - id is the id for the key location lookup
     */
    func dropKeyLocation(id: Int64) {
        let query = keyLocations.filter(idColumn == id)
        do {
            try db!.run(query.delete())
        } catch {
            print("Unable to delete key location")
        }
    }
    
    /*
     * getNearestKeyLocation returns the closest location by distance (haversine)
     * @return - Key location closest to current device location
     */
    func getNearestKeyLocation() -> KeyLocation? {
        // TODO: Perhaps this should do an intelligent query on the db
        // but for now we'll assume that there just aren't many keylocations, so this is
        // not too expensive.
        let keyLocations = self.getAll()
        if keyLocations.count == 0 {
            return nil
        }
        else {
            let currentLocation = LocationManager.sharedInstance.getLocation()
            var nearestKeyLocation = (keyLocations[0] as! KeyLocation)
            var minDist = Location.getDistance(currentLocation, point2: nearestKeyLocation.getLocation())
            for keyLocation in keyLocations {
                let curDist = Location.getDistance(currentLocation, point2: (keyLocation as! KeyLocation).getLocation())
                if (curDist < minDist) {
                    nearestKeyLocation = keyLocation as! KeyLocation
                    minDist = curDist
                }
            }
            return nearestKeyLocation
        }
    }
    
}