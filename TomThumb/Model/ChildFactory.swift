//
//  Child.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import Foundation
import UIKit

struct Child: Equatable, Identifiable {
    var id: Int
    var name: String
}

struct ChildFactory {
    var children: [Child] = []
    
    init() {
        children.append(Child(id: 1, name: "Enrico"))
        children.append(Child(id: 2, name: "Kilo"))
        children.append(Child(id: 3, name: "Filippo"))
        children.append(Child(id: 4, name: "Mario"))
        children.append(Child(id: 5, name: "Lucia"))
        children.append(Child(id: 6, name: "Anna"))
        children.append(Child(id: 7, name: "Antioco"))
        

    }
    
}
