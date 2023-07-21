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
import Amplify
import Combine

struct MapView: View {

    @State var centerCoordinate: CLLocationCoordinate2D?
    @State var annotations: [MKPointAnnotation] = []
    @State var reports: [Report]?
    @EnvironmentObject private var locationManager: LocationManager
    @State var tracking: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0307), span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
    @State private var showAddReport = false
    @State private var showAddNotification = false
    @State var reportSupscription: AnyCancellable?
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $tracking, annotationItems: annotations) {
            annotation in
            MapMarker(coordinate: annotation.coordinate)
        } // Add showsUserLocation parameter
                .ignoresSafeArea(.all)
                .onAppear {
                    updateAnnotations(with: region.center)
                    //print(LocationManager.shared.lastKnownLocation)
                    
                    LocationManager.shared.requestLocation() { location in
                        setRegion(location: location)
                        print(location)
                        updateAnnotations(with: region.center)
                    }
                    setRegion(location: LocationManager.shared.lastKnownLocation)
                    
                    
                }
                .onChange(of: region) { newRegion in
                    let location = newRegion.center
                    setRegion(location: location)
                    updateAnnotations(with: location)
                    //setRegion(location: location) // Update the region when the location changes
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
                                print(location)
                            }
                            setRegion(location: LocationManager.shared.lastKnownLocation)
                           
                        } label: {
                            Image(systemName: "location.fill")
                        }
                        .buttonBorderShape(.capsule)
                    }
                    
                    .padding()
                }
        
        
    }
    
    func updateAnnotations(with coordinate: CLLocationCoordinate2D) {
            // Here, you can perform any logic to fetch or update the annotations
            // based on the new map center (coordinate)
            
            // For example, let's add a random annotation to demonstrate
            let reports = Report.keys
            self.reportSupscription = Amplify.Publisher.create(
                Amplify.DataStore.observeQuery(
                    for: Report.self,
                    where: reports.longitude > coordinate.longitude + 0.005 && reports.longitude < coordinate.longitude - 0.005
                    && reports.latitude < coordinate.latitude + 0.005 && reports.latitude > coordinate.latitude - 0.005
                )
            )
            .sink {
                if case .failure(let error) = $0 {
                    print("Error \(error)")
                }
            } receiveValue: { querySnapshot in
                print("[Snapshot] item count: \(querySnapshot.items.count), isSynced: \(querySnapshot.isSynced)")
                //print(querySnapshot.items)
                self.annotations = []
                querySnapshot.items.forEach() { report in
                    let randomAnnotation = MKPointAnnotation()
                    randomAnnotation.coordinate.latitude = CLLocationDegrees(Double(report.latitude!)!)
                    randomAnnotation.coordinate.longitude = CLLocationDegrees(Double(report.longitude!)!)
                    
                    self.annotations.append(randomAnnotation)
                    
                }
                print(annotations)
                
                //annotations = [randomAnnotation]
            }
    }
    
   
    private func setRegion(location: CLLocation? = nil) {
        if location == nil {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0307), span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
        } else if let userLocation = location {
            region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
        }
    }
    
    private func setRegion(location: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
     
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center == rhs.center && lhs.span == rhs.span
    }
}

extension MKPointAnnotation: Identifiable { }
