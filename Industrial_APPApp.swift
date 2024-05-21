//
//  Industrial_APPApp.swift
//  Industrial_APP
//
//  Created by User on 2023/12/29.
//

import SwiftUI
import FirebaseCore

// AppDelegate class to handle Firebase configuration during app launch
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

// Main entry point for the app
@main
struct Industrial_APPApp: App {
    // Connect the AppDelegate for handling app lifecycle events
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Define the main scene for the app
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
