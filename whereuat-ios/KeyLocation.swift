//
//  KeyLocation.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 4/18/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import Foundation

class KeyLocation: Model {
    var name: String
    var longitude: Double
    var latitude: Double
    
    init(name: String, longitude: Double, latitude: Double) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
}