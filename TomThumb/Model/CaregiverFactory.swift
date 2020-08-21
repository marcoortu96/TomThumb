//
//  CaregiverFactory.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import UIKit

struct Caregiver {
    let id = UUID()
    var img: UIImage
    var name: String
    var email: String
    var username: String
    var password: String
    var phoneNumber: String
    var children: [Child]
    
    /*init(name: String, surname: String, cellphone: String) {
        self.name = name
        self.surname = surname
        self.cellphone = cellphone
    }*/
    
    
}

struct CaregiverFactory {
    var caregivers: [Caregiver] = []
    
    init() {
        caregivers.append(Caregiver(img: UIImage(named: "sora1")!, name: "Marco", email: "Ortu", username: "sora", password: "sora", phoneNumber: "3491114782", children: [ChildFactory().children[0], ChildFactory().children[1]]))
        caregivers.append(Caregiver(img: UIImage(named: "zoro")!, name: "Andrea", email: "andreare@mail.com", username: "Andrew", password: "1234", phoneNumber: "3491114782", children: [ChildFactory().children[2], ChildFactory().children[6]]))

    }
    
}

