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

class LocationSender {
    
    var toPhoneNumber: String
    var lat: Double
    var long: Double
    
    init(toPhoneNumber: String, lat: Double, long: Double) {
        self.toPhoneNumber = toPhoneNumber
        self.lat = lat
        self.long = long
    }
    
    func sendLocation() {
        let fromPhoneNumber = NSUserDefaults.standardUserDefaults().stringForKey("phoneNumber")!
        let parameters = [
            "from" : fromPhoneNumber,
            "to" : self.toPhoneNumber,
            "current-location": [
                    "lat" : self.lat,
                    "lng" : self.long
            ],
            "key-location" : NSNull()
            ]
        print(parameters)
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