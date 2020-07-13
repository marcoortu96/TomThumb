//
//  CaregiverFactory.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import UIKit

struct CaregiverFactory {
    var caregivers: [Caregiver] = []
    
    init() {
        caregivers.append(Caregiver(id: 1, img: UIImage(named: "sora1")!, name: "Marco", email: "Ortu", username: "sora", password: "sora", phoneNumber: 123, children: [Child(id: 1, name: "Enrico"), Child(id: 2, name: "Kilo")]))

    }
    
}

