//
//  Crumb.swift
//  TomThumb
//
//  Created by Andrea Re on 19/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import MapKit

struct Crumb {
    var location: CLLocationCoordinate2D
    var audio: URL?
    
    init(location: CLLocationCoordinate2D) {
        self.location = location
    }
    
    init(location: CLLocationCoordinate2D, audio: URL) {
        self.location = location
        self.audio = audio
    }

}
