//
//  Location.swift
//  whereuat
//
//  Created by Raymond Jacobson on 4/26/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation

class Location {
    
    var long: Double
    var lat: Double
    
    init(long: Double, lat: Double) {
        self.long = long
        self.lat = lat
    }
    
    class func degreesToRadians(degrees: Double) -> Double { return degrees * M_PI / 180.0 }
    class func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / M_PI }
    
    class func getDistance(point1: Location, point2: Location) -> Double {
        
        let lat1 = degreesToRadians(point1.lat)
        let lon1 = degreesToRadians(point1.long)
        
        let lat2 = degreesToRadians(point2.lat);
        let lon2 = degreesToRadians(point2.long);
        
        let radius: Double = 3959.0 // Miles
        
        let deltaP = (degreesToRadians(lat1) - degreesToRadians(lat2))
        let deltaL = (degreesToRadians(lon1) - degreesToRadians(lon2))
        let a = sin(deltaP/2) * sin(deltaP/2) + cos(degreesToRadians(lat2)) * cos(degreesToRadians(lat2)) * sin(deltaL/2) * sin(deltaL/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        let d = radius * c
        
        return d
    }
}