//
//  ContentView.swift
//  SafeWalk
//
//  Created by Riyad Sarsour on 6/26/23.
//

import SwiftUI
import UIKit
import MapKit

struct ContentView: View {
    var mapView = MapView()
    @StateObject var locationManager = LocationManager() // Change to @StateObject

    @State private var isTrackingEnabled = true

    var body: some View {
        MapView()
            .environmentObject(locationManager)
            .onAppear(perform: {
                
            })
    }
}

struct SuspiciousActivityAlert: View {
    @EnvironmentObject private var locationManager: LocationManager
    @State private var showAlert = false

    var body: some View {
        VStack {
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Suspicious Activity Reported"), message: Text("Please be cautious and confirm if the activity is still present."), dismissButton: .default(Text("OK")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
