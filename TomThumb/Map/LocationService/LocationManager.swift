//
//  LocationManager.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import Combine
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject{
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    var currentLocation: CLLocation?
    var initial: Bool = true
    var userHeading: CLLocationDirection!
    var locations: [CLLocation] = []
    
    public override init() {
        super.init()
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        requestAuthorization(locationManager: locationManager)
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
    }
    
    public func requestAuthorization(locationManager: CLLocationManager) {
        locationManager.requestWhenInUseAuthorization()
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatingLocation(locationManager: locationManager)
        case .denied, .notDetermined, .restricted:
            stopUpdatingLocation(locationManager: locationManager)
        @unknown default:
            print("Fatal: requestAuthorization failed")
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy < 0 { return }
        
        let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        userHeading = heading
        NotificationCenter.default.post(name: Notification.Name(rawValue:"myNotificationName"), object: self, userInfo: nil)
    }
    
    public func startUpdatingLocation(locationManager: CLLocationManager) {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    public func stopUpdatingLocation(locationManager: CLLocationManager) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.last != nil else { return }
        
        for location in locations {
            delegate?.trackingLocation(for: location)
        }
        
        currentLocation = manager.location
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error as NSError)
    }
    
    public func updateLocation(currentLocation: CLLocation) {
        guard let delegate = delegate else { return }
        delegate.trackingLocation(for: currentLocation)
    }
    
    public func updateLocationDidFailWithError(error: Error) {
        guard let delegate = delegate else { return }
        delegate.trackingLocationDidFail(with: error)
    }
}
