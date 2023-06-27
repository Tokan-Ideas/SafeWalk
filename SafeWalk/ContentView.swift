//
//  ContentView.swift
//  SafeWalk
//
//  Created by Riyad Sarsour on 6/26/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager() // Change to @StateObject

    @State private var isTrackingEnabled = false

    var body: some View {
        VStack {
            Toggle("Enable Location Tracking", isOn: $isTrackingEnabled)
                .padding()

            if isTrackingEnabled {
                MapView()
                    .environmentObject(locationManager) // Add this line
                SuspiciousActivityAlert()
                    .environmentObject(locationManager) // Add this line
            } else {
                Text("Location Tracking is Disabled")
                    .font(.headline)
                    .padding()
            }
        }
    }
}

struct SuspiciousActivityAlert: View {
    @EnvironmentObject private var locationManager: LocationManager
    @State private var showAlert = false

    var body: some View {
        VStack {
            if locationManager.isSuspiciousActivityNearby {
                Text("Suspicious Activity Reported Nearby!")
                    .font(.headline)
                    .padding()

                if locationManager.isCloseToSuspiciousActivity {
                    Text("Confirm if activity is still present:")
                        .font(.subheadline)
                        .padding()

                    Button("Yes") {
                        // Handle confirmation logic when suspicious activity is confirmed
                    }
                    .padding()
                    .foregroundColor(.green)

                    Button("No") {
                        // Handle confirmation logic when suspicious activity is not present
                    }
                    .padding()
                    .foregroundColor(.red)
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Suspicious Activity Reported"), message: Text("Please be cautious and confirm if the activity is still present."), dismissButton: .default(Text("OK")))
        }
        .onReceive(locationManager.$isSuspiciousActivityNearby) { isSuspiciousActivityNearby in
            showAlert = isSuspiciousActivityNearby
        }
    }
}

struct MapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0307), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true) // Add showsUserLocation parameter
            .ignoresSafeArea(edges: .all)
            .onAppear {
                setRegion() // Update the region when the map appears
            }
            .onChange(of: locationManager.lastKnownLocation) { location in
                guard let location = location else { return }
                setRegion(location: location) // Update the region when the location changes
            }
    }

    private func setRegion(location: CLLocation? = nil) {
        if let location = location {
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        } else if let userLocation = locationManager.lastKnownLocation {
            region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



