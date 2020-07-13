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
        caregivers.append(Caregiver(id: 1, img: UIImage(named: "sora1")!, name: "Marco", email: "Ortu", username: "sora", password: "sora", phoneNumber: "123", children: [ChildFactory().children[0], ChildFactory().children[1]]))
        caregivers.append(Caregiver(id: 1, img: UIImage(named: "zoro")!, name: "Andrea", email: "andreare@mail.com", username: "Andrew", password: "1234", phoneNumber: "456", children: [ChildFactory().children[2], ChildFactory().children[6]]))

    }
    
}

