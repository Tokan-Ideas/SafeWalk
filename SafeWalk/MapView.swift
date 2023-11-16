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

@available(iOS 16.4, *)
struct MapView: View {
    @State var centerCoordinate: CLLocationCoordinate2D?
    @State var annotations: [GenericMapAnnotation] = []
    @State var reports: [Report]?
    @EnvironmentObject private var locationManager: LocationManager
    @State var tracking: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(center: LocationManager.shared.lastKnownLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090), span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
    @State private var showAddReport = false
    @State private var showAddNotification = false
    @State var reportSupscription: AnyCancellable?
    @State private var overlaying = true
    @State private var searchResults = [MKMapItem]()
    @State private var mapSelection: MKMapItem?
    @State private var showSelected = false
    @State private var searchText = ""
    @State private var getDirections = false
    
    private var queue = DispatchQueue.global(qos: .background)//DispatchQueue(label: "Annotation Queue", qos: .background, autoreleaseFrequency: .inherit)
    
    var body: some View {

    
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking, annotationItems: annotations) {
            annotation in
            
            MapAnnotation(coordinate: annotation.coordinate!) {
                if (annotation.annotationType == "Report") {
                    
                    AnnotationView(reportType: annotation.reportType!, reportId: annotation.reportId!, coordinates: annotation.coordinate!, report: annotation.report!, showSelected: $showSelected, showSearch: $overlaying)
                        .frame(width: 30, height: 30)
                } else {
                        MapPinView(annotation: annotation, mapItem: annotation.mapItem!, coordinate: annotation.coordinate!)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                self.mapSelection = annotation.mapItem
                                print("SELECTION SELECTED")
                                self.showSelected = true
                            }
                }
                
            }
            
    
        } // Add showsUserLocation parameter
        .overlay(alignment: .topTrailing) {
            HStack(alignment: .top) {
                VStack(alignment: .trailing, spacing: 20) {
                    Spacer()
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
                    .padding()
                    
                }
                .padding(.top)
            }
            .frame(width: 40, height: 40)
            .padding()
        }
        .sheet(isPresented: $showSelected) {
            LocationDetailView(mapSelection: $mapSelection, show: $showSelected, getDirections: $getDirections)
                .presentationDetents([.fraction(0.5)])
                .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.5)))
//                .onAppear {
//                    self.overlaying = false
//                }
 
        }
        .sheet(isPresented: $overlaying, content: {
            MapOverlayView(searchResults: self.$searchResults, searchText: self.$searchText)
                .presentationDetents([.fraction(0.1), .fraction(0.5), .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.5)))
                .overlay(alignment: .topTrailing) {
                    HStack() {
                        Spacer()
                        Button("Report") {
                            showAddReport.toggle()
        //                    print(locationManager.lastKnownLocation)
        //                    print(region)
                        }
                        .fullScreenCover(isPresented: $showAddReport, content: {
                            ReportView(coordinates: LocationManager.shared.lastKnownLocation!.coordinate, reports: self.reports)
                        })
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                }
            
//                .edgesIgnoringSafeArea(.all)
          
        })
                .ignoresSafeArea(.all)
                .onAppear {
                    updateAnnotations(with: region.center, span: region.span)
                    //print(LocationManager.shared.lastKnownLocation)
                    LocationManager.shared.requestLocation() { location in
                        setRegion(location: location)
                        updateAnnotations(with: region.center, span: region.span)
                    }
                    setRegion(location: LocationManager.shared.lastKnownLocation)
                    
                    self.showSelected = self.mapSelection != nil
                    self.overlaying = !self.showSelected
                }
                .onChange(of: region) { newRegion in
                    let location = newRegion.center
//                    self.overlaying = true
                    setRegion(location: location)
                    updateAnnotations(with: location, span: region.span)
                    self.showSelected = self.mapSelection != nil && searchText != ""
                    self.overlaying = !self.showSelected
                
                    
                    //setRegion(location: location) // Update the region when the location changes
                }
//                .onReceive(region.debounce(for: .milliseconds(500), scheduler: RunLoop.main)) { region in
//                    let location = region.center
//                    setRegion(location: location)
//                    updateAnnotations(with: location)
//                }
//                .overlay(alignment: .topLeading) {
//                    HStack(spacing: 20) {
//                        Spacer()
//                        Button("Report") {
//                            showAddReport.toggle()
//                        }
//                        .fullScreenCover(isPresented: $showAddReport, content: {
//
//                            ReportView(coordinates: region.center, reports: self.reports)
//                        })
//                        .buttonStyle(.borderedProminent)
//                        .buttonBorderShape(.capsule)
//                        .controlSize(.large)
//                    }
//                    .padding()
//                }
        
        
        
    }
    
    func updateAnnotations(with coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan) {
            // Here, you can perform any logic to fetch or update the annotations
            // based on the new map center (coordinate)
            
            // For example, let's add a random annotation to demonstrate
        print(self.searchResults)
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
                        let pin = GenericMapAnnotation(
                            annotationType: "Report",
                            reportType: report.reportType!,
                            reportId: report.id,
                            coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(report.latitude!)!), longitude: CLLocationDegrees(Double(report.longitude!)!)),
                            report: report, mapItem: nil
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
                
                for place in self.searchResults {
                    let placemark = place.placemark
                    let ant = GenericMapAnnotation(annotationType: "ResultPin", reportType: nil, reportId: nil, coordinate: placemark.coordinate, report: nil, mapItem: place)
                    self.annotations.append(ant)
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
