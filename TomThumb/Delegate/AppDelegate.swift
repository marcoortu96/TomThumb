//
//  AppDelegate.swift
//  TomThumb
//
//  Created by Marco Ortu on 13/07/2020.
//  Copyright © 2020 Sora. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Init Firebase
        FirebaseApp.configure()
        
        // Flag isExecuting = false se si lancia l'app
        let dbRef = Database.database().reference()
        dbRef.child("Assisted").child("isExecuting").setValue(false)
        dbRef.child("Assisted").child("collected").setValue(0)
        
        // Download audio dallo storage al lancio dell'app
        fetchAudios()
        
        // Al lancio dell'app il blocco schermo automatico rimane attivo
        UIApplication.shared.isIdleTimerDisabled = false

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

