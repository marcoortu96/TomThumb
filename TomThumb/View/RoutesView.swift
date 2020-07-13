//
//  RoutesView.swift
//  TomThumb
//
//  Created by Andrea Re on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

var routes = RoutesFactory().routes

struct RoutesView: View {
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)
                List(routes.filter {
                    self.searchText == "" ? true : $0.routeName.localizedCaseInsensitiveContains(searchText)
                    }, id: \.self)
                { route in
                    NavigationLink(destination: RouteDetail(route: route)) {
                        Text(route.routeName)
                    }
                    
                }.navigationBarTitle("Percorsi")
            }
        }.accentColor(.blue)
    }
    
}


struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView()
    }
}

