//
//  AddRouteView.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

struct AddRouteView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Inizia a registrare il percorso").font(.headline).fontWeight(.medium).multilineTextAlignment(.center).padding(.bottom, 70.0)
                Button(action: {
                    print("heyyyyy")
                }) {
                    Image(systemName: "play.circle").font(.system(size: 250)).foregroundColor(.green)
                }
                
            }
            .padding(.bottom, 100.0)
            .navigationBarTitle("Aggiungi")
        }
    }
}

struct AddRouteView_Previews: PreviewProvider {
    static var previews: some View {
        AddRouteView()
    }
}
