//
//  AddRouteView.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit


var locationManager = CLLocationManager()


struct AddRouteView: View {
    
    @Binding var showSheetView: Bool
    @State private var searchText = ""
    @State var centerCoordinate: CLLocationCoordinate2D
    @State private var locations = [MKPointAnnotation]()
    @ObservedObject var audioRecorder: AudioRecorder
    @State var showingAudioAlert = false
    @State var crumbAudio: URL
    @State var currentCrumb: Crumb
    @State var crumbs: [Crumb]
    
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                SearchBar(searchText: $searchText)
                ZStack {
                    MapViewAddRoute(centerCoordinate: $centerCoordinate, annotations: locations)
                    Image(systemName: "largecircle.fill.circle")
                        .opacity(0.6)
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                let newLocation = MKPointAnnotation()
                                newLocation.title = self.locations.count == 0 ? "start" : String(self.locations.count)
                                newLocation.coordinate = self.centerCoordinate
                                self.locations.append(newLocation)
                                self.showingAudioAlert = true
                                self.currentCrumb = Crumb(location: CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude))
                                
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.green.opacity(0.85))
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                            .padding(.bottom)
                        }
                    }
                    // Show popup for add audio to a crumb
                    if self.showingAudioAlert {
                        GeometryReader {_ in
                            PopupAudio(showingAudioAlert: self.$showingAudioAlert, audioRecorder: self.audioRecorder, selectedAudio: self.crumbAudio, currentCrumb: self.$currentCrumb, crumbs: self.$crumbs)
                        }
                        .background(Color.black.opacity(0.90))
                        .cornerRadius(15)
                        .frame(width: (UIScreen.main.bounds.size.width/100) * 85, height: (UIScreen.main.bounds.size.height/100) * 60)
                    }
                }
                HStack {
                    //Remove last annotation
                    Button(action: {
                        if self.locations.count != 0 {
                            self.locations.remove(at: (self.locations.count-1))
                        }
                    }) {
                        Text("Annulla")
                            .foregroundColor((self.showingAudioAlert || self.locations.count == 0) ? Color.red.opacity(0.3) : Color.red)
                    }
                    .padding()
                    .disabled(self.showingAudioAlert || self.locations.count == 0)
                    Spacer()
                    Button(action: {
                        //Save new route
                        var start: Crumb
                        var finish: Crumb

                        start = self.crumbs[0]
                        finish = self.crumbs[self.crumbs.count-1]
                        self.crumbs.removeFirst()
                        self.crumbs.removeLast()
                        let mapRoute = MapRoute(start: start, crumbs: self.crumbs, finish: finish)
                        let newRoute = Route(routeName: "New", user: ChildFactory().children[0].name, caregiver: CaregiverFactory().caregivers[0], mapRoute: mapRoute)
                        RoutesFactory.insertRoute(route: newRoute)
                        print(RoutesFactory.getInstance().getRoutes())
                        self.showSheetView = false
                    }) {
                        Text("Salva")
                            .foregroundColor((self.showingAudioAlert || self.locations.count <= 2) ? Color.blue.opacity(0.3) : Color.blue)
                    }
                    .padding()
                    .disabled(self.showingAudioAlert || self.locations.count <= 2)
                }
            }
            .navigationBarTitle("Aggiungi", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showSheetView = false
            }) {
                Text("Indietro").bold()
                }.disabled(self.showingAudioAlert))
        }
    }
}

struct PopupAudio: View {
    @Binding var showingAudioAlert: Bool
    @ObservedObject var audioRecorder: AudioRecorder
    @State var selectedAudio: URL
    @Binding var currentCrumb: Crumb
    @Binding var crumbs: [Crumb]
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Spacer()
            Text("Seleziona audio")
                .font(.system(size: 18))
                .fontWeight(.bold)
            RecordingsList(audioRecorder: self.audioRecorder, selectedAudio: self.$selectedAudio)
            if self.audioRecorder.recording == false {
                Button(action: {self.audioRecorder.startRecording()}) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipped()
                        .foregroundColor(.red)
                }
            } else {
                Button(action: {self.audioRecorder.stopRecording()}) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipped()
                        .foregroundColor(.red)
                }
            }
            Button(action: {
                self.showingAudioAlert.toggle()
                self.crumbs.append(Crumb(location: self.currentCrumb.location, audio: self.selectedAudio))
                
            }) {
                Text("Conferma inserimento")
                    .foregroundColor(self.selectedAudio.lastPathComponent.count < 2 ? Color.gray : InterfaceConstants.genericLinkForegroundColor)
            }.disabled(self.selectedAudio.lastPathComponent.count < 2)
            Spacer()
        }
    }
}
