//
//  LocationManager.swift
//  SafeWalk
//
//  Created by Riyad Sarsour on 6/26/23.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()

    @Published var lastKnownLocation: CLLocation? // Track the user's last known location
    static let shared = LocationManager()    
    override init() {
        super.init()
        locationManager.delegate = self
        //locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @Published var isSuspiciousActivityNearby = false
    @Published var isCloseToSuspiciousActivity = false
    
    private let suspiciousActivityRadius: CLLocationDistance = 3_218.69 // 2 miles in meters
    
    private var reportedSuspiciousActivityLocation: CLLocation? // Location of the reported suspicious activity
    
    func requestLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func checkSuspiciousActivity(location: CLLocation) {
        // Simulated logic for demonstration purposes
        let reportedSuspiciousActivityLatitude = 37.3352
        let reportedSuspiciousActivityLongitude = -122.0096
        
        let reportedSuspiciousActivityLocation = CLLocation(latitude: reportedSuspiciousActivityLatitude, longitude: reportedSuspiciousActivityLongitude)
        
        let distance = location.distance(from: reportedSuspiciousActivityLocation)
        
        isSuspiciousActivityNearby = distance <= suspiciousActivityRadius
        isCloseToSuspiciousActivity = distance <= 1_609.34 // 1 mile in meters
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lastKnownLocation = location // Update the last known location
            checkSuspiciousActivity(location: location)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .notDetermined:
                
                print("ND")
                break
            case .restricted:
                print("Restricted")
                break
            case .denied:
                print("Denied")
                break
            case .authorizedAlways:
                print("Always")
                manager.startUpdatingLocation()
                break
            case .authorizedWhenInUse:
                print("When In Use")
                manager.startUpdatingLocation()
                break
            @unknown default:
                print("FUCKED UP")
        }
    }
//    func locationMan {
//        switch status {
//        case .notDetermined:
//            print("ND")
//            
//        case .restricted:
//            print("Restricted")
//            
//        case .denied:
//            print("Denied")
//            
//        case .authorizedAlways:
//            print("Always")
//            
//        case .authorizedWhenInUse:
//            print("When In Use")
//            
//        }
    
}
