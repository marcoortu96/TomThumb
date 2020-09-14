//
//  RouteDetail.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit
import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

struct RouteDetail: View {
    @ObservedObject var route: Route
    @State var showingDeleteAlert = false
    @State var showingSendedAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Form {
            Section(header: Text("Nome").font(.body).bold()) {
                HStack {
                    Image(systemName: "pencil.circle.fill").foregroundColor(Color.yellow).font(.title)
                    NavigationLink(destination: ChangeRouteName(route: route)) {
                        VStack {
                            Text(route.routeName)
                        }
                    }
                }
            }
            Section(header: Text("Dettagli").font(.body).bold()) {
                HStack {
                    Image(systemName: "mappin.circle.fill").foregroundColor(Color.red).font(.title)
                    Text("Inizio")
                    Spacer()
                    Text("\(route.startName)").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                }
                HStack {
                    Image(systemName: "mappin.circle.fill").foregroundColor(Color.green).font(.title)
                    Text("Fine")
                    Spacer()
                    Text("\(route.finishName)").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                }
                HStack {
                    Image(systemName: "number.circle.fill").foregroundColor(Color.gray).font(.title)
                    Text("Molliche")
                    Spacer()
                    Text("\(route.crumbs)").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                }
                HStack {
                    Image(systemName: "equal.circle.fill").foregroundColor(Color.orange).font(.title)
                    Text("Distanza")
                    Spacer()
                    Text("\(route.distance.short)m").foregroundColor(InterfaceConstants.secondaryInfoForegroundColor)
                }
            }
            Section(header: Text("Mappa").font(.body).bold()) {
                HStack {
                    Image(systemName: "location.circle.fill").foregroundColor(Color.yellow).font(.title)
                    NavigationLink(destination: MapView(mapRoute: route.mapRoute)) {
                        Text("Visualizza il percorso")
                    }.accentColor(InterfaceConstants.genericLinkForegroundColor)
                }
            }
            Section(header: Text("Prova").font(.body).bold()) {
                HStack {
                    Image(systemName: "play.circle.fill").foregroundColor(Color.green).font(.title)
                    NavigationLink(destination: ARView(route: route, debug: true)) {
                        Text("Avvia il test del percorso")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .foregroundColor(InterfaceConstants.positiveLinkForegroundColor)
                    }
                    
                }
            }
            
            Section(header: Text("Condivisione").font(.body).bold()) {
                ZStack {
                    Image(systemName: "arrowshape.turn.up.right.circle.fill").foregroundColor(Color.blue).font(.title)
                        .padding(.trailing, (UIScreen.main.bounds.width/100)*76.5)
                    Button(action: {
                        //Send route to user
                        self.showingSendedAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            self.showingSendedAlert = false
                        }
                        self.sendRoute()
                    }) {
                        Text("Invia percorso")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .foregroundColor(InterfaceConstants.genericLinkForegroundColor)
                    }.alert(isPresented: self.$showingSendedAlert) {
                        Alert(title: Text("Condivisione"),
                              message: Text("Il percorso è stato inviato"), dismissButton: .none)
                    }
                }
                
            }
            Section(header: Text("Elimina percorso").font(.body).bold()) {
                ZStack {
                    Image(systemName: "trash.circle.fill").foregroundColor(Color.red).font(.title)
                        .padding(.trailing, (UIScreen.main.bounds.width/100)*76.5)
                    Button(action: {
                        self.showingDeleteAlert = true
                    }) {
                        Text("Elimina")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .foregroundColor(InterfaceConstants.negativeLinkForegroundColor)
                    }.alert(isPresented: self.$showingDeleteAlert) {
                        Alert(title: Text("Eliminazione"),
                              message: Text("Vuoi eliminare questo percorso?"),
                              primaryButton: Alert.Button.destructive(
                                Text("Elimina"), action: {
                                    self.deleteRoute()
                                    self.presentationMode.wrappedValue.dismiss()
                              }),
                              secondaryButton: Alert.Button.cancel(Text("Annulla"), action: {
                              }))
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle(Text("Dati percorso"), displayMode: .inline)
        .onAppear {
            // Riattiva blocco schermo automatico quando si torna alla view precedente
            UIApplication.shared.isIdleTimerDisabled = false
        }
        
    }
    
    func sendRoute() {
        let ref = Database.database().reference()
        
        ref.child("Assisted").updateChildValues(
            [
                "collected" : 0,
                "isExecuting" : true,
                "id" : self.route.id
        ])
        
        ref.child("Routes").child(self.route.id).updateChildValues(
            [
                "lastExecution" : Date().toString(dateFormat: "dd.MM.yyyy HH:mm:ss")
            ]
        )
        
    }
    
    func deleteRoute() {
        let db = Database.database().reference()
        
        // Rimozione della route dal db
        
        db.child("Routes").child(self.route.id).removeValue() { (error, ref) in
            if error != nil {
                print("error \(error.debugDescription)")
            }
        }
        
        db.child("Assisted").observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? NSDictionary
            
           let id = value?["id"] as? String ?? "err"
            
            if id == self.route.id {
                db.child("Assisted").child("id").setValue("null")
                db.child("Assisted").child("isExecuting").setValue(false)
            }
            
        }
        
        // Rimozione della route dalla lista delle route mostrate nella view
        //self.routes.remove(atOffsets: offsets)
        
    }
    
    struct ChangeRouteName: View {
        @ObservedObject var route: Route
        @State var isEditing = false
        
        var body: some View {
            Form {
                Section(header: Text("Modifica nome")) {
                    ZStack(alignment: .trailing) {
                        TextField("Name", text: $route.routeName, onEditingChanged: {_ in self.isEditing = true})
                        Button(action: {
                            self.route.routeName = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .opacity((!self.isEditing || self.route.routeName == "") ? 0 : 1)
                        }
                    }
                    
                }
            }
            .navigationBarTitle(Text("Nome"), displayMode: .inline)
            .onDisappear(perform: updateRoute)
        }
        
        func updateRoute() {
            let ref = Database.database().reference()
            
            ref.child("Routes").child(route.id).updateChildValues(["routeName": route.routeName])
            
            RoutesFactory.getInstance().setRoutes(routes: RoutesFactory.getInstance().getRoutes())
        }
    }
}

/*struct RouteDetail_Previews: PreviewProvider {
 static var previews: some View {
 RouteDetail(route: Route(routeName: "Prima", user: "Filippo", caregiver: CaregiverFactory().caregivers[0], mapRoute: MapRoutesFactory().mapRoutes[0]))
 }
 }*/
