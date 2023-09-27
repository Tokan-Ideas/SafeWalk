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
    @State var annotations: [ReportAnnotation] = []
    @State var reports: [Report]?
    @EnvironmentObject private var locationManager: LocationManager
    @State var tracking: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(center: LocationManager.shared.lastKnownLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090), span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
    @State private var showAddReport = false
    @State private var showAddNotification = false
    @State var reportSupscription: AnyCancellable?
    private var queue = DispatchQueue.global(qos: .background)//DispatchQueue(label: "Annotation Queue", qos: .background, autoreleaseFrequency: .inherit)
    
    var body: some View {

    
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking, annotationItems: annotations) {
            annotation in
            
            MapAnnotation(coordinate: annotation.coordinate) {
                AnnotationView(reportType: annotation.reportType, reportId: annotation.reportId, coordinates: annotation.coordinate, report: annotation.report)
                    .onDisappear(){
                        updateAnnotations(with: region.center, span: region.span)
                    }
                
            }
        } // Add showsUserLocation parameter
                .ignoresSafeArea(.all)
                .onAppear {
                    updateAnnotations(with: region.center, span: region.span)
                    //print(LocationManager.shared.lastKnownLocation)
                    
                    LocationManager.shared.requestLocation() { location in
                        setRegion(location: location)
                        print(location)
                        queue.async {
                            updateAnnotations(with: region.center, span: region.span)
                        }
                    }
                    setRegion(location: LocationManager.shared.lastKnownLocation)
                    
                    
                }
                .onChange(of: region) { newRegion in
                    let location = newRegion.center
                    DispatchQueue.main.async {
                        setRegion(location: location)
                        queue.suspend()
                        queue.asyncAfter(deadline: .now()+2){
                            updateAnnotations(with: location, span: region.span)
                        }
                    }
                    
                
                    
                    //setRegion(location: location) // Update the region when the location changes
                }
//                .onReceive(region.debounce(for: .milliseconds(500), scheduler: RunLoop.main)) { region in
//                    let location = region.center
//                    setRegion(location: location)
//                    updateAnnotations(with: location)
//                }
                .overlay(alignment: .topLeading) {
                    HStack(spacing: 20) {
                        Spacer()
                        Button("Report") {
                            showAddReport.toggle()
                        }
                        .fullScreenCover(isPresented: $showAddReport, content: {

                            ReportView(coordinates: region.center, reports: self.reports)
                        })
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
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
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                
                        }
                        .buttonBorderShape(.capsule)
                        
                    }
                    .padding()
                }
        
        
    }
    
    func updateAnnotations(with coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan) {
            // Here, you can perform any logic to fetch or update the annotations
            // based on the new map center (coordinate)
            
            // For example, let's add a random annotation to demonstrate
            let reports = Report.keys
            let span2 = span.longitudeDelta * 2
            self.reportSupscription = Amplify.Publisher.create(
                Amplify.DataStore.observeQuery(
                    for: Report.self,
                    where: reports.longitude > coordinate.longitude + span2 && reports.longitude < coordinate.longitude - span2
                    && reports.latitude < coordinate.latitude + span2 && reports.latitude > coordinate.latitude - span2
                    && reports.negatedCounter < 2
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
                DispatchQueue.main.async {
                    querySnapshot.items.forEach() { report in


                        //annote.$region = MKCoord
                        let pin = ReportAnnotation(
                            reportType: report.reportType!,
                            reportId: report.id,
                            coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(report.latitude!)!), longitude: CLLocationDegrees(Double(report.longitude!)!)),
                            report: report
                        )
    //                    pin.reportTye = report.reportType
    //                    pin.reportId = report.id
    //                    pin.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(report.latitude!)!), longitude: CLLocationDegrees(Double(report.longitude!)!))
                        
    //                    let randomAnnotation = MKPointAnnotation()
    //                    randomAnnotation.coordinate.latitude = CLLocationDegrees(Double(report.latitude!)!)
    //                    randomAnnotation.coordinate.longitude = CLLocationDegrees(Double(report.longitude!)!)
                        
                        
                        self.annotations.append(pin)
                        
                    }
                    self.reports = querySnapshot.items
                }
                
                //print(annotations)
                
                //annotations = [randomAnnotation]
                //reportSupscription?.cancel()
            }
        
    }
    
   
    private func setRegion(location: CLLocation? = nil) {
        if location == nil {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0307), span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))

        } else if let userLocation = location {
            region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
            
//            region.center = userLocation.coordinate
        }
    }
    
    private func setRegion(location: CLLocationCoordinate2D) {
        //region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
        region.center = location
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
