//
//  LocationManager.swift
//  whereuat
//
//  Created by Raymond Jacobson on 4/26/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation
import CoreLocation

/*
 * LocationManager manages location of the current device and supplies information about it
 * when invoked.
 */
class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    
    let locationManager = CLLocationManager()
    // The current location
    var location: CLLocationCoordinate2D!
    
    /*
     * init starts the location updating service
     */
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
    
    /*
     * getLocation gets the current location
     * @return the location as a Location type
     */
    func getLocation() ->  Location {
        return Location(long: self.location.longitude, lat: self.location.longitude)
    }
    
    /*
     * sendLocation is a helper method that invokes the LocationSender to send a location
     * to a phone number
     * @param toPhoneNumber - the phone number to send location to
     */
    func sendLocation(toPhoneNumber: String) {
        let loc = Location(long: self.location.longitude, lat: self.location.latitude)
        let locSender = LocationSender(toPhoneNumber: toPhoneNumber, location: loc)
        locSender.sendLocation()
    }
    
    /*
     * locationManager updates the internal LocationManager location
     */
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = manager.location!.coordinate
    }
}