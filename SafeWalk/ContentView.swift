//
//  ContentView.swift
//  SafeWalk
//
//  Created by Riyad Sarsour on 6/26/23.
//

import SwiftUI
import UIKit
import MapKit

import Amplify

struct ContentView: View {
    @StateObject var locationManager = LocationManager() // Change to @StateObject

    @State private var isTrackingEnabled = true

    var body: some View {

        if #available(iOS 17.0, *) {
            ModernMapView()
                .onAppear(perform: {
                LocationManager.shared.requestLocation() { location in
                    LocationManager.shared.lastKnownLocation = location
                    locationManager.lastKnownLocation = location
                    
                }
                Task {
                    Task {
                        do {
                            try await Amplify.DataStore.clear()
                            //                            print("Local data cleared successfully.")
                        } catch {
                            //                            print("Local data not cleared \(error)")
                        }
                    }
                    LocationManager.shared.requestLocation() { location in
                        LocationManager.shared.lastKnownLocation = location
                        locationManager.lastKnownLocation = location
                        
                    }
                }
                
            })
            .environmentObject(locationManager)
        } else if #available(iOS 16.4, *){
            
            MapView()
                .onAppear(perform: {
                    LocationManager.shared.requestLocation() { location in
                        LocationManager.shared.lastKnownLocation = location
                        locationManager.lastKnownLocation = location
                        
                    }
                    Task {
                        Task {
                            do {
                                try await Amplify.DataStore.clear()
                                //                            print("Local data cleared successfully.")
                            } catch {
                                //                            print("Local data not cleared \(error)")
                            }
                        }
                        LocationManager.shared.requestLocation() { location in
                            LocationManager.shared.lastKnownLocation = location
                            locationManager.lastKnownLocation = location
                            
                        }
                    }
                    
                })
                .environmentObject(LocationManager.shared)
        }
    }
}
//
//struct SuspiciousActivityAlert: View {
//    @EnvironmentObject private var locationManager: LocationManager
//    @State private var showAlert = false
//
//    var body: some View {
//        VStack {
//        }
//        .padding()
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Suspicious Activity Reported"), message: Text("Please be cautious and confirm if the activity is still present."), dismissButton: .default(Text("OK")))
//        }
//    }
//}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
