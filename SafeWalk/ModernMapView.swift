//
//  ModernMapView.swift
//  SafeWalk
//
//  Created by Rahqi Sarsour on 9/20/23.
//

import SwiftUI
import MapKit
import Amplify
import Combine

@available(iOS 17.0, *)
struct ModernMapView: View {
    @State var centerCoordinate: CLLocationCoordinate2D?
    @State private var annotations: [ReportAnnotation] = []
    @State var reports: [Report]?
    @EnvironmentObject private var locationManager: LocationManager
    @State var tracking: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(center: LocationManager.shared.lastKnownLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090), span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
    @State private var showAddReport = false
    @State private var showAddNotification = false
    @State var reportSupscription: AnyCancellable?
    private var queue = DispatchQueue.global(qos: .background)
    
    
    @Namespace var mapScope
    @State private var mapSelection = MKMapItem?.self
    @State private var results = [MKMapItem]()
    var body: some View {
        Map(initialPosition: .region(region)) {
            //UserAnnotation()
            
            
            
            ForEach(annotations) { annotation in
                Annotation("", coordinate: annotation.coordinate) {
                    AnnotationView(reportType: annotation.reportType, reportId: annotation.reportId, coordinates: annotation.coordinate, report: annotation.report)
                        .onDisappear(){
                            updateAnnotations(with: region.center, span: region.span)
                        }
                }
            }
            
            UserAnnotation()
        }
        .onMapCameraChange({ context in
            setRegion(location: context.region.center)
            updateAnnotations(with: context.region.center, span: context.region.span)
            locationManager.requestLocation { loc in
                locationManager.lastKnownLocation = loc
                LocationManager.shared.lastKnownLocation = loc
            }
        })
        .onAppear {
            setRegion(location: region.center)
            updateAnnotations(with: region.center, span: region.span)
        }
        .overlay(alignment: .bottomTrailing) {
            HStack(spacing: 20) {
                Spacer()
                Button("Report") {
                    showAddReport.toggle()
                    print(locationManager.lastKnownLocation)
                    print(region)
                }
                .fullScreenCover(isPresented: $showAddReport, content: {

                    ReportView(coordinates: locationManager.lastKnownLocation?.coordinate ?? region.center, reports: self.reports)
                })
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.extraLarge)
            }
            .padding()
        }
        .mapControls {
            MapUserLocationButton(scope: mapScope)
                .controlSize(.extraLarge)
            MapCompass(scope: mapScope)
        }
        .mapControlVisibility(.automatic)
        
//        .overlay(alignment: .bottomTrailing) {
//            MapUserLocationButton(scope: mapScope)
//        }
//        .overlay(alignment: .bottomTrailing) {
//            VStack(spacing: 20) {
//                
//                Button {
//                    print("Recenter")
//                    LocationManager.shared.requestLocation { location in
//                        setRegion(location: location)
//                        print(location)
//                    }
//                    setRegion(location: LocationManager.shared.lastKnownLocation)
//                   
//                } label: {
//                    Image(systemName: "location.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 40, height: 40)
//                        
//                }
//                .buttonBorderShape(.capsule)
//                
//            }
//            .padding()
//        }
        
        //MapCompass()
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
    
    func updateAnnotations(with coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan) {
            // Here, you can perform any logic to fetch or update the annotations
            // based on the new map center (coordinate)
            //print("RUN SHIT")
            // For example, let's add a random annotation to demonstrate
            let reports = Report.keys
            let span2 = span.longitudeDelta * 2
            self.reportSupscription = Amplify.Publisher.create(
                Amplify.DataStore.observeQuery(
                    for: Report.self,
                    where: reports.longitude > coordinate.longitude + span.longitudeDelta && reports.longitude < coordinate.longitude - span.longitudeDelta && reports.latitude < coordinate.latitude + span.latitudeDelta && reports.latitude > coordinate.latitude - span.latitudeDelta
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
                        //print("SHIT RUNNING")

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
}
//
//extension CLLocationCoordinate2D: Equatable {
//    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
//        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
//    }
//}
//
//extension MKCoordinateSpan: Equatable {
//    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
//        lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
//    }
//}
//
//extension MKCoordinateRegion: Equatable {
//    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
//        lhs.center == rhs.center && lhs.span == rhs.span
//    }
//}
//

//#Preview {
//    if #available(iOS 17.0, *) {
//        ModernMapView()
//    } else {
//        // Fallback on earlier versions
//    }
//}
