//
//  LocationManager.swift
//  whereuat
//
//  Created by Raymond Jacobson on 4/26/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

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
    
    /*
     * stringToCLLocationDegrees converts a latitude or longitude string value to a
     * CLLocationDegrees type
     * @param value - string degrees value of latitude or longitude
     * @return value as CLLocationDegrees type
     */
    class func stringToCLLocationDegrees(value: String) -> CLLocationDegrees {
        return CLLocationDegrees(value)!
    }
    
    /*
     * openMapsWithLocation opens the default Maps application with a given lat and lng
     * as well as the name of the placemarker.
     * @param lat - latitude of location to open
     * @param lng - longitude of location to open
     * @param placemarker - the name of the placemarker
     */
    class func openMapsWithLocation(lat: CLLocationDegrees, lng: CLLocationDegrees, placemarker: String) {
        // Dispatching this task as async makes it switch to the Maps app much faster
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(lat, lng)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = placemarker
            mapItem.openInMapsWithLaunchOptions(options)
        })
    }
}