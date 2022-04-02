//
//  boiKhataApp.swift
//  boiKhata
//
//  Created by Dhruba Chakraborty on 31/3/22.
//

import SwiftUI
import Firebase

@main
struct boiKhataApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate 
    
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
