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
    @StateObject var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        Task {
            LocationManager.shared.requestLocation() { location in
                LocationManager.shared.lastKnownLocation = location                
            }
            let hubEventSubscriber = Amplify.Hub.publisher(for: .dataStore).sink { event in
                if event.eventName == HubPayload.EventName.DataStore.networkStatus {
                    guard let networkStatus = event.data as? NetworkStatusEvent else {
                        print("Failed to cast data as NetworkStatusEvent")
                        return
                    }
                    print("User receives a network connection status: \(networkStatus.active)")
                }
            }
        }
        
        do {
            // AmplifyModels is generated in the previous step
            let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSPinpointPushNotificationsPlugin(options: [.badge, .alert, .sound]))
            try Amplify.configure()
            
            print("Amplify configured with DataStore plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
        
        
    }
    
}
