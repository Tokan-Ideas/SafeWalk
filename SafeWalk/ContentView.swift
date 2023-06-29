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

    @State private var isTrackingEnabled = true

    var body: some View {
        MapView()
            .environmentObject(locationManager)
            .onAppear(perform: {
                locationManager.requestLocation()
            })// Add this line
//        `VStack {
//            Toggle("Enable Location Tracking", isOn: $isTrackingEnabled)
//                .padding()
//
//            if isTrackingEnabled {
//                MapView()
//                    .environmentObject(locationManager) // Add this line
//                SuspiciousActivityAlert()
//                    .environmentObject(locationManager) // Add this line
//            } else {
//                Text("Location Tracking is Disabled")
//                    .font(.headline)
//                    .padding()
//            }
//        }`
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
    @State var tracking: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0307), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking) // Add showsUserLocation parameter
                .ignoresSafeArea(.all)
                .onAppear {
                    setRegion(location: LocationManager.shared.lastKnownLocation)
//
                    //setRegion() // Update the region when the map appears
                }
                .onChange(of: locationManager.lastKnownLocation) { location in
                    guard let location = location else { return }
                    setRegion(location: location) // Update the region when the location changes
                }
                .overlay(alignment: .topLeading) {
                    HStack(spacing: 20) {
                        Button {
                            print("Recent Alerts")
                            
                        } label: {
                            Image(systemName: "bell.fill")
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        Spacer()
                        Button("Report") {
                            print("Report Pressed")
                        }
                        //                    } label: {
                        //                        
                        //                    }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                    }
                    .padding()
                }
                .overlay(alignment: .bottomTrailing) {
                    VStack(spacing: 20) {
//                        if #available(iOS 17, *) {
//                            MapCompass()
//                            MapUserLocationButton()
//                        } else {
//                            Button {
//                                print("Left Pressed")
//                            } label: {
//                                Image(systemName: "bell.fill")
//                            }
//                        }
                        Button {
                            print("Left Pressed")
                            locationManager.requestLocation()
                            setRegion(location: locationManager.lastKnownLocation)
                        } label: {
                            Image(systemName: "location.fill")
                        }
                        //.buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                    }
                    
                    .padding()
                }
                
//                .mapControlVisibility(.visible)
        
                Spacer()
                
                
        
    }

    private func setRegion(location: CLLocation? = nil) {
        if location == nil {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0307), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
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



