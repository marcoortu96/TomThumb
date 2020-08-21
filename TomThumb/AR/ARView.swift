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

struct ARView: View {
    @ObservedObject var locationManager = LocationManager()
    @State var actualCrumb = 0
    @State var lookAt = 0
    @State var nPlays = 0
    // TEST point-segment
    @State var prevCrumb = LocationNode(location: CLLocation())
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var showingEndARAlert = false
    var route: Route
    var debug: Bool
    
    @State var isShowing = true
    
    @State var size: CGFloat = 0.7
    var repeatingAnimation: Animation {
        Animation
            .linear(duration: 0.8)
            .repeatForever()
    }
    
    var body: some View {
        ZStack {
            ARViewController(route: route, actualCrumb: $actualCrumb, lookAt: $lookAt, prevCrumb: $prevCrumb, nPlays: $nPlays)
            
            //Directional arrows section
            
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
                        .scaleEffect(size)
                        .onAppear() {
                            withAnimation(self.repeatingAnimation) { self.size = 0.8 }
                        }
                        .onDisappear() {
                            self.size = 0.7
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
                        .scaleEffect(size)
                        .onAppear() {
                            withAnimation(self.repeatingAnimation) { self.size = 0.8 }
                        }
                        .onDisappear() {
                            self.size = 0.7
                        }
                }

            //Route percentage section
            ZStack {
                Text("\(actualCrumb)/\(route.mapRoute.crumbs.count)")
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
            
            if !debug {
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
                    .padding(.top, (UIScreen.main.bounds.size.height/100) * 75)
                    .padding(.trailing, (UIScreen.main.bounds.size.width/100) * 77)
                }
                
                //Help section
                ZStack {
                    Button(action: {
                        print("Help")
                        
                    }) {
                        Image(systemName: "questionmark")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.85))
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.top, (UIScreen.main.bounds.size.height/100) * (debug ? 70 : 75))
                    .padding(.leading, (UIScreen.main.bounds.size.width/100) * 77)
                }
            }
            if self.actualCrumb == self.route.mapRoute.crumbs.count {
                GeometryReader { _ in
                    PopUpTerminated()
                }.background(Color.black.opacity(0.90))
                    .cornerRadius(15)
                    .frame(width: (UIScreen.main.bounds.size.width/100) * 75, height: (UIScreen.main.bounds.size.height/100) * 20)
            }
            if self.nPlays >= 2 && isShowing {
                
                GeometryReader { _ in
                    PopUpCall(caregiver: self.route.caregiver, isShowing: self.$isShowing)
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
    
    @State var caregiver: Caregiver
    @Binding var isShowing: Bool
    
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
                    self.isShowing = false
                    
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

/*
 struct ARView_Previews: PreviewProvider {
 static var previews: some View {
 ARView()
 }
 }
 */
