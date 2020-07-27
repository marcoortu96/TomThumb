//
//  SearchBar.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit

struct SearchBar: View {
    
    @Binding var searchText: String
    @State private var showCancelButton: Bool = false
    
    var onCommit: () ->Void = {

    }
        
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                // Search text field
                ZStack (alignment: .leading) {
                    if searchText.isEmpty { // Separate text for placeholder to give it the proper color
                        Text("Cerca")
                    }
                    TextField("", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                        // Convert address in a coordinate for search in the map
                        let geocoder = CLGeocoder()
                        geocoder.geocodeAddressString(self.searchText) { (placemarks, error) in

                            if let center = (placemarks?.first?.region as? CLCircularRegion)?.center {

                                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                                mapView.setRegion(region, animated: true)
                            }
                        }
                    }, onCommit: onCommit).foregroundColor(.primary)
                }
                // Clear button
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary) // For magnifying glass and placeholder test
            .background(Color(.tertiarySystemFill))
            .cornerRadius(10.0)
            
            if showCancelButton  {
                // Cancel button
                Button("Annulla") {
                    self.searchText = ""
                    let resign = #selector(UIResponder.resignFirstResponder)
                    UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(.horizontal)
        //uncomment the next line to hide the navigationBar title while entering text
        //.navigationBarHidden(showCancelButton)
    }
    
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
