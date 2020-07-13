//
//  ProfileDetail.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import SwiftUI

import SwiftUI

struct profileDetail: View {
    var caregiver: Caregiver
    var body: some View {
            VStack {
                Image(uiImage: caregiver.img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90, alignment: .center)
                    .clipped()
                    .clipShape(Circle())
                    .shadow(radius: 1)
                Form {
                    Section(header: Text("Nome")) {
                        NavigationLink(destination: ChangeName(name: caregiver.name)) {
                            VStack {
                                Text(caregiver.name)
                            }
                        }
                    }
                    Section(header: Text("Username")) {
                        NavigationLink(destination: ChangeUsername(username: caregiver.username)) {
                            VStack {
                                Text(caregiver.username)
                            }
                        }
                    }
                    Section(header: Text("Email")) {
                        NavigationLink(destination: ChangeEmail(email: caregiver.email)) {
                            VStack {
                                Text(caregiver.email)
                            }
                        }
                    }
                    Section(header: Text("Numero di telefono")) {
                        NavigationLink(destination: ChangeNum(num: String(caregiver.phoneNumber))) {
                            VStack {
                                Text(String(caregiver.phoneNumber))
                            }
                        }
                    }
                    Section(header: Text("Bambini")) {
                        List(CaregiverFactory().caregivers[0].children) { child in
                            ChildRow(child: child)
                        }
                    }
                }
                .accentColor(.blue)
            }
            .navigationBarTitle("Profilo")
    }
}

struct ChangeName: View {
    @State var name: String
    var body: some View {
        Form {
            Section(header: Text("Modifica nome")) {
                VStack {
                    TextField("Name", text: $name)
                }
            }
        }
    }
}

struct ChangeUsername: View {
    @State var username: String
    var body: some View {
        Form {
            Section(header: Text("Modifica username")) {
                VStack {
                    TextField("Username", text: $username)
                }
            }
        }
    }
}

struct ChangeEmail: View {
    @State var email: String
    var body: some View {
        Form {
            Section(header: Text("Modifica email")) {
                VStack {
                    TextField("Email", text: $email)
                }
            }
        }
    }
}

struct ChangeNum: View {
    @State var num: String
    var body: some View {
        Form {
            Section(header: Text("Modifica numero")) {
                VStack {
                    TextField("Numero", text: $num).keyboardType(.numberPad)
                }
            }
        }
    }
}

struct ChildRow: View {
    var child: Child
    var body: some View {
        Text(child.name)
    }
}


struct profileDetail_Previews: PreviewProvider {
    static var previews: some View {
        profileDetail(caregiver: CaregiverFactory().caregivers[0])
    }
}
