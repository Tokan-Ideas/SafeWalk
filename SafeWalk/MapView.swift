//
//  MapView.swift
//  SafeWalk
//
//  Created by Riyad Sarsour on 7/16/23.
//

import Foundation
import SwiftUI
import UIKit
import MapKit


struct MapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @State var tracking: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0307), span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0024))
    @State private var showAddReport = false
    @State private var showAddNotification = false

    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking) // Add showsUserLocation parameter
                .ignoresSafeArea(.all)
                .onAppear {
                    locationManager.requestLocation() { location in
                        setRegion(location: location)
                        print(location)
                    }
                    
                    print(LocationManager.shared.lastKnownLocation)
                    print(locationManager.lastKnownLocation)
                }
                .onChange(of: locationManager.lastKnownLocation) { location in
                    guard let location = location else { return }
                    setRegion(location: location) // Update the region when the location changes
                }
                .overlay(alignment: .topLeading) {
                    HStack(spacing: 20) {
                        Spacer()
                        Button("Report") {
                            showAddReport.toggle()
                        }
                        .fullScreenCover(isPresented: $showAddReport, content: {
                            ReportView()
                        })
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                    }
                    .padding()
                }
                .overlay(alignment: .bottomTrailing) {
                    VStack(spacing: 20) {
                        
                        Button {
                            print("Recenter")
                            LocationManager.shared.requestLocation { location in
                                setRegion(location: location)
                            }
                            
                            locationManager.requestLocation { location in
                                setRegion(location: locationManager.lastKnownLocation)
                                print(locationManager.lastKnownLocation)
                            }
                            
                            setRegion(location: locationManager.lastKnownLocation)
                                                    
                            
                        } label: {
                            Image(systemName: "location.fill")
                        }
                        .buttonBorderShape(.capsule)
                    }
                    
                    .padding()
                }
        
    }

    private func setRegion(location: CLLocation? = nil) {
        if location == nil {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0307), span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
        } else if let userLocation = location {
            region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
        }
    }
}
