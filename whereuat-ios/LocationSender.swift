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
    var lat: String
    var long: String
    
    init(toPhoneNumber: String, lat: String, long: String) {
        self.toPhoneNumber = toPhoneNumber
        self.lat = lat
        self.long = long
    }
    
    func sendLocation() {
        func requestLocationFromContact(sender: UITapGestureRecognizer) {
            let fromPhoneNumber = NSUserDefaults.standardUserDefaults().stringForKey("phoneNumber")!
            
            let parameters = [
                "from" : fromPhoneNumber,
                "to" : self.toPhoneNumber,
                "current-location": [
                        "lat" : 42.727940,
                        "lng" : -73.68986
                ],
                "key-location" : NSNull()
                ]
            Alamofire.request(.POST, "http://whereuat.xyz/at", parameters: parameters, encoding: .JSON)
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

}