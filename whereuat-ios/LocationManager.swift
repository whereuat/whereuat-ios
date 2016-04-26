//
//  LocationManager.swift
//  whereuat
//
//  Created by Raymond Jacobson on 4/26/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    
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
    
    func getLocation() ->  Location {
        return Location(long: self.location.longitude, lat: self.location.longitude)
    }
    
    func sendLocation(toPhoneNumber: String) {
        let loc = Location(long: self.location.longitude, lat: self.location.latitude)
        let locSender = LocationSender(toPhoneNumber: toPhoneNumber, location: loc)
        locSender.sendLocation()
    }
    
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = manager.location!.coordinate
    }
}