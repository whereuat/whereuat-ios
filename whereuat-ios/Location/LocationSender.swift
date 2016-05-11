//
//  LocationSender.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 4/6/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

/*
 * LocationSender tracks a location and a destination number and sends a message
 */
class LocationSender {
    
    var toPhoneNumber: String
    var location: Location
    
    init(toPhoneNumber: String, location: Location) {
        self.toPhoneNumber = toPhoneNumber
        self.location = location
    }
    
    /*
     * sendLocation uses the current location and toPhoneNumber to send a the location via
     * http POST request
     */
    func sendLocation() {
        // Get currenty user's phoneNumber
        let fromPhoneNumber = NSUserDefaults.standardUserDefaults().stringForKey("phoneNumber")!
        let nearestKeyLocation = Database.sharedInstance.keyLocationTable.getNearestKeyLocation()
        var keyLocation: AnyObject?
        if (nearestKeyLocation != nil) {
            keyLocation = [
                "name" : nearestKeyLocation!.name,
                "geometry" : [
                    "location" : [
                        "lat" : nearestKeyLocation!.latitude,
                        "lng" : nearestKeyLocation!.longitude
                    ]
                ]
            ]
        } else {
            keyLocation = NSNull()
        }
        var parameters: Dictionary = [
            "from" : fromPhoneNumber,
            "to" : self.toPhoneNumber,
            "current-location": [
                "lat" : self.location.lat,
                "lng" : self.location.long
            ],
        ]
        parameters.updateValue(keyLocation as! NSObject, forKey: "key-location")

        Alamofire.request(.POST, Global.serverURL + "/at", parameters: parameters, encoding: .JSON)
            .validate()
            .responseString { response in
                switch response.result {
                case .Success:
                    debugPrint(response)
                    print("Location sent:", self.toPhoneNumber)
                case .Failure(let error):
                    print(error)
                    print("Failed to send location:", self.toPhoneNumber)
                }
        }

    }

}