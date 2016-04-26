//
//  Location.swift
//  whereuat
//
//  Created by Raymond Jacobson on 4/26/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = Location()
    
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D!
    
    override init() {
        super.init()
        // Grant location permissions
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func sendLocation(toPhoneNumber: String) {
        let locSender = LocationSender(toPhoneNumber: toPhoneNumber, lat: self.location.latitude, long: self.location.longitude)
        locSender.sendLocation()
    }
    
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = manager.location!.coordinate
    }
}