//
//  SafeWalkApp.swift
//  SafeWalk
//
//  Created by Riyad Sarsour on 6/26/23.
//

import SwiftUI
import Amplify
import AWSDataStorePlugin
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSPinpointPushNotificationsPlugin

@main
struct SafeWalkApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        do {
            // AmplifyModels is generated in the previous step
            let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSPinpointPushNotificationsPlugin(options: [.badge, .alert, .sound]))
            try Amplify.configure()
            
            print("Amplify configured with DataStore plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
        
        
    }
    
}
