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
    @StateObject var locationManager = LocationManager() // Change to @StateObject

    @State private var isTrackingEnabled = true

    var body: some View {
        MapView()
            .environmentObject(locationManager)
            .onAppear(perform: {
                
            })// Add this line {
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
//            if locationManager.isSuspiciousActivityNearby {
//                Text("Suspicious Activity Reported Nearby!")
//                    .font(.headline)
//                    .padding()
//
//                if locationManager.isCloseToSuspiciousActivity {
//                    Text("Confirm if activity is still present:")
//                        .font(.subheadline)
//                        .padding()
//
//                    Button("Yes") {
//                        // Handle confirmation logic when suspicious activity is confirmed
//                    }
//                    .padding()
//                    .foregroundColor(.green)
//
//                    Button("No") {
//                        // Handle confirmation logic when suspicious activity is not present
//                    }
//                    .padding()
//                    .foregroundColor(.red)
//                }
//            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Suspicious Activity Reported"), message: Text("Please be cautious and confirm if the activity is still present."), dismissButton: .default(Text("OK")))
        }
//        .onReceive(locationManager.$isSuspiciousActivityNearby) { isSuspiciousActivityNearby in
//            showAlert = isSuspiciousActivityNearby
//        }
    }
}

struct MapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @State var tracking: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0307), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @State private var showAddReport = false

    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking) // Add showsUserLocation parameter
                .ignoresSafeArea(.all)
                .onAppear {
                    locationManager.requestLocation() { location in
                        setRegion(location: location)
                        print(location)
                    }
                    
//                    print(LocationManager.shared.lastKnownLocation)
                    print(locationManager.lastKnownLocation)
//
                    setRegion() // Update the region when the map appears
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
                            showAddReport.toggle()
                        }
                        .fullScreenCover(isPresented: $showAddReport, content: {
                            ReportView()
                        })
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
                            print("Recenter")
                            LocationManager.shared.requestLocation { location in
                                setRegion(location: location)
                                print(location)
                            }
                            
                            
                            
                            
                        } label: {
                            Image(systemName: "location.fill")
                        }
                        //.buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                    }
                    
                    .padding()
                }
                
//                .mapControlVisibility(.visible)
                
        
    }

    private func setRegion(location: CLLocation? = nil) {
        if location == nil {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0307), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        } else if let userLocation = location {
            region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//struct LocationButton: UIViewRepresentable {
//    func updateUIView(_ uiView: MKUserTrackingButton, context: Context) {
//        print("FUCK")
//    }
//    
//    func makeUIView(context: Context) -> MKUserTrackingButton {
//
//            return MKUserTrackingButton()
//        }
//}
//
//
//
