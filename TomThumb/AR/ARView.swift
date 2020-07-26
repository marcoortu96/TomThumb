//
//  ARView.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

struct ARView: View {
    @ObservedObject var locationManager = LocationManager()
    @State var actualCrumb = 0
    var route: MapRoute
    
    var body: some View {
        ZStack {
            ARViewController(route: route, actualCrumb: $actualCrumb)
            ZStack {
                Text("\(actualCrumb)/\(route.crumbs.count)")
                Circle()
                    .fill(Color.clear)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .trim(from: 0, to: CGFloat((Double(Double(actualCrumb) / Double(route.crumbs.count)) * 100) * (0.01)))
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .fill(Color.red)
                )
                
            }.padding(.top, (UIScreen.main.bounds.size.height/100) * 64)
                .padding(.trailing, (UIScreen.main.bounds.size.width/100) * 74)
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
