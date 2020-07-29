//
//  Crumb.swift
//  TomThumb
//
//  Created by Andrea Re on 19/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import MapKit


class Crumb {
    var location: CLLocation
    var audio: URL?
    
    init(location: CLLocation) {
        self.location = location
    }
    
    init(location: CLLocation, audio: URL) {
        self.location = location
        self.audio = audio
    }
}
