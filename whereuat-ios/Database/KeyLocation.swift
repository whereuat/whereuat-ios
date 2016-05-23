//
//  KeyLocation.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 4/18/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import Foundation

/*
 * KeyLocation stores relevant information for a key location
 */
class KeyLocation: Model {
    var id: Int64?
    var name: String
    var longitude: Double
    var latitude: Double
    
    /*
     * Initializing a key location without an id will cause the SQL database to automatically
     * assign it
     */
    init(name: String, longitude: Double, latitude: Double) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init(id: Int64, name: String, longitude: Double, latitude: Double) {
        self.id = id
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
    
    func getLocation() -> Location {
        return Location(long: self.longitude, lat: self.latitude)
    }
}