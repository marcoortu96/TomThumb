//
//  AssistedView.swift
//  TomThumb
//
//  Created by Marco Ortu on 18/08/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import Firebase

struct AssistedView: View {
    @State var textFromDB = ""
    var body: some View {
        VStack {
            Text("Polling:\n \(textFromDB)")
            Button(action: {
                self.readDataFromDB()
            }) {
                Text("PRESS ME!").accentColor(.white).background(Color(.blue))
            }
        }
    }
    
    func readDataFromDB() {
        let ref = Database.database().reference()
        ref.child("Assisted").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user position value
            let value = snapshot.value as? NSDictionary
            let lat = value?["latitude"] as? Double ?? 0.0
            let lon = value?["longitude"] as? Double ?? 0.0
            
            self.textFromDB = "lat: \(lat)\n lon: \(lon)"
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}

struct AssistedView_Previews: PreviewProvider {
    static var previews: some View {
        AssistedView()
    }
}
