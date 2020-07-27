//
//  LocationServiceDelegate.swift
//  TomThumb
//
//  Created by Andrea Re on 22/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    func trackingLocation(for currentLocation: CLLocation)
    func trackingLocationDidFail(with error: Error)
}
