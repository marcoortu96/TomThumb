//
//  ARView.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI
import MapKit
import ARCL
import Firebase
import AVFoundation
import FirebaseDatabase
import FirebaseStorage


struct ARView: View {
    @ObservedObject var locationManager = LocationManager()
    @State var actualCrumb = 0 
    @State var lookAt = 0
    @State var nPlays = 0
    @State var prevCrumb = LocationNode(location: CLLocation())
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var showAnimation = false
    
    var route: Route
    @State var debug: Bool
    
    @State var showingEndARAlert = false
    @State var showingCallAlert = true
    @State var showingHelpAlert = false
    
    @State var arrowSize: CGFloat = 0.7
    @State var thumbSize: CGFloat = 0.7
    var repeatingAnimation: Animation {
        Animation
            .linear(duration: 3.0)
            .repeatForever()
    }
    
    var body: some View {
        ZStack {
            ARViewController(route: route, actualCrumb: $actualCrumb, lookAt: $lookAt, prevCrumb: $prevCrumb, nPlays: $nPlays, animation: $showAnimation, isTesting: debug)
            
            //Directional arrows section
            
            if showAnimation {
                Image(systemName: "hand.thumbsup.fill")
                .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .rotationEffect(.degrees(0))
                    .frame(width: 30, height: 30)
                    .foregroundColor(.yellow)
                    .padding(.bottom, (UIScreen.main.bounds.size.height/100) * 25)
                    .padding(.leading, (UIScreen.main.bounds.size.width/100) * 20)
                    .scaleEffect(thumbSize)
                    .onAppear() {
                        withAnimation(self.repeatingAnimation) { self.thumbSize = 3.8 }
                }
                .onDisappear() {
                    self.thumbSize = 0.7
                }
                Image(systemName: "hand.thumbsup.fill")
                .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .frame(width: 30, height: 30)
                    .foregroundColor(.yellow)
                    .padding(.bottom, (UIScreen.main.bounds.size.height/100) * 25)
                    .padding(.trailing, (UIScreen.main.bounds.size.width/100) * 20)
                    .scaleEffect(thumbSize)
                    .onAppear() {
                        withAnimation(self.repeatingAnimation) { self.thumbSize = 3.8 }
                }
                .onDisappear() {
                    self.thumbSize = 0.7
                }
            }
            
            if lookAt == 1 {
                //look left
                Image(systemName: "shift.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .rotationEffect(.degrees(-90))
                    .frame(width: 50, height: 50)
                    .foregroundColor(InterfaceConstants.genericLinkForegroundColor)
                    .padding(.bottom, (UIScreen.main.bounds.size.height/100) * 45)
                    .padding(.trailing, (UIScreen.main.bounds.size.width/100) * 99)
                    .scaleEffect(arrowSize)
                    .onAppear() {
                        withAnimation(self.repeatingAnimation) { self.arrowSize = 0.8 }
                }
                .onDisappear() {
                    self.arrowSize = 0.7
                }
                
            } else if lookAt == 2 {
                //look right
                Image(systemName: "shift.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .rotationEffect(.degrees(90))
                    .frame(width: 50, height: 50)
                    .foregroundColor(InterfaceConstants.genericLinkForegroundColor)
                    .padding(.bottom, (UIScreen.main.bounds.size.height/100) * 45)
                    .padding(.leading, (UIScreen.main.bounds.size.width/100) * 99)
                    .scaleEffect(arrowSize)
                    .onAppear() {
                        withAnimation(self.repeatingAnimation) { self.arrowSize = 0.8 }
                }
                .onDisappear() {
                    self.arrowSize = 0.7
                }
            }
            
            //Route percentage section \(actualCrumb)/\(route.mapRoute.crumbs.count)
            ZStack {
                Text("\(self.actualCrumb)/\(self.route.crumbs)")
                Circle()
                    .fill(Color.clear)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .trim(from: 0, to: CGFloat((Double(Double(actualCrumb) / Double(route.mapRoute.crumbs.count)) * 100) * (0.01)))
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .fill(Color.red)
                )
                
            }.padding(.bottom, (UIScreen.main.bounds.size.height/100) * (debug ? 68 : 75))
                .padding(.trailing, (UIScreen.main.bounds.size.width/100) * 75)
            //Stop ARView section
            ZStack {
                Button(action: {
                    self.showingEndARAlert = true
                }) {
                    Image(systemName: "stop.fill")
                        .foregroundColor(.white)
                }
                .alert(isPresented: self.$showingEndARAlert) {
                    Alert(title: Text("Termina"), message: Text("Vuoi terminare questo test?"), primaryButton: Alert.Button.default(Text("OK"), action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            let dbRef = Database.database().reference()
                            dbRef.child("Assisted").updateChildValues(["isExecuting" : false])
                        }
                        self.presentationMode.wrappedValue.dismiss() //back to previous page
                    }),
                          secondaryButton: Alert.Button.cancel(Text("Annulla"), action: {
                          }))
                }
                .padding()
                .background(Color.red.opacity(0.85))
                .font(.title)
                .clipShape(Circle())
                .padding(.bottom, (UIScreen.main.bounds.size.height/100) * (debug ? 70 : 75))
                .padding(.leading, (UIScreen.main.bounds.size.width/100) * 77)
            }
            
            if debug {
                //Call caregiver section
                ZStack {
                    Button(action: {
                        print("Calling caregiver")
                        let url: NSURL = URL(string: "tel://+393491114782")! as NSURL
                        UIApplication.shared.open(url as URL)
                        
                    }) {
                        Image(systemName: "phone")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.green.opacity(0.85))
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.top, (UIScreen.main.bounds.size.height/100) * 70)
                    .padding(.trailing, (UIScreen.main.bounds.size.width/100) * 77)
                }
                
                //Help section
                ZStack {
                    Button(action: {
                        print("Help")
                        self.showingHelpAlert = true
                        
                    }) {
                        Image(systemName: "questionmark")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.85))
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.top, (UIScreen.main.bounds.size.height/100) * 70)
                    .padding(.leading, (UIScreen.main.bounds.size.width/100) * 77)
                }
            }
            if self.showingHelpAlert {
                GeometryReader { _ in
                    PopUpHelp(caregiver: self.route.caregiver, isShowing: self.$showingHelpAlert)
                }.background(Color.black.opacity(0.90))
                    .cornerRadius(15)
                    .frame(width: (UIScreen.main.bounds.size.width/100) * 75, height: (UIScreen.main.bounds.size.height/100) * 20)
            }
            
            if self.actualCrumb == self.route.mapRoute.crumbs.count {
                GeometryReader { _ in
                    PopUpTerminated()
                }.background(Color.black.opacity(0.90))
                    .cornerRadius(15)
                    .frame(width: (UIScreen.main.bounds.size.width/100) * 75, height: (UIScreen.main.bounds.size.height/100) * 20)
            }
            if self.nPlays >= 1 && showingCallAlert {
                
                GeometryReader { _ in
                    PopUpCall(caregiver: self.route.caregiver, isShowing: self.$showingCallAlert, nPlays: self.$nPlays)
                }.background(Color.black.opacity(0.90))
                    .cornerRadius(15)
                    .frame(width: (UIScreen.main.bounds.size.width/100) * 75, height: (UIScreen.main.bounds.size.height/100) * 20)
            }
        }
        
    }

}

struct PopUpTerminated: View {
    var body: some View {
        Text("Percorso completato")
            .font(.title)
    }
}

struct PopUpCall: View {
    
    var caregiver: Caregiver
    @Binding var isShowing: Bool
    @Binding var nPlays: Int
    
    var body: some View {
        VStack {
            Text("Chiama \(self.caregiver.name)")
            HStack {
                Button(action: {
                    print("Calling caregiver")
                    self.isShowing = false
                    let url: NSURL = URL(string: "tel://\(self.caregiver.phoneNumber)")! as NSURL
                    UIApplication.shared.open(url as URL)
                    
                }) {
                    Image(systemName: "phone")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.green.opacity(0.85))
                .font(.title)
                .clipShape(Circle())
                Spacer().frame(width: (UIScreen.main.bounds.size.width/100) * 25)
                Button(action: {
                    self.nPlays = 0
                    self.isShowing = true
                    
                }) {
                    Image(systemName: "multiply")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.red.opacity(0.85))
                .font(.title)
                .clipShape(Circle())
            }
        }
        
    }
}

struct PopUpHelp: View {
    
    var caregiver: Caregiver
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            Text("Cosa succede?")
            HStack {
                Button(action: {
                    //MARK: - Aggiungere riproduzione audio in caso di sconosciuti
                    print("Stranger")
                    let store = Storage.storage()
                    let ref = store.reference()
                    
                    let audio = ref.child("audio/start1.m4a")
                    
                    let path = audio.fullPath.split(separator: "/")[1]
                    
                    print(path)
                    
                    let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(String(path))
                    
                    var player = AVAudioPlayer()
                    
                    audio.getData(maxSize: 3 * 1024 * 1024) { (data, error) in
                        if let error = error {
                            print("error \(error)")       
                        } else {
                            if let d = data {
                                do {
                                    try d.write(to: fileUrl)
                                    player = try AVAudioPlayer(contentsOf: fileUrl)
                                    player.play()
                                } catch {
                                    print("error")
                                }
                            }
                        }
                    }
                    self.isShowing = false
                }) {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.green.opacity(0.85))
                .font(.title)
                .clipShape(Circle())
                Spacer().frame(width: (UIScreen.main.bounds.size.width/100) * 25)
                Button(action: {
                    print("Obstacle")
                    self.isShowing = false
                    let url: NSURL = URL(string: "tel://\(self.caregiver.phoneNumber)")! as NSURL
                    UIApplication.shared.open(url as URL)
                }) {
                    Image(systemName: "triangle.fill")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.red.opacity(0.85))
                .font(.title)
                .clipShape(Circle())
            }
        }
        
    }
}

/*
 struct ARView_Previews: PreviewProvider {
 static var previews: some View {
 ARView()
 }
 }
 */
