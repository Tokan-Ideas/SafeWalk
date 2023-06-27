//
//  LocationManager.swift
//  SafeWalk
//
//  Created by Riyad Sarsour on 6/26/23.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()

    @Published var lastKnownLocation: CLLocation? // Track the user's last known location

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    @Published var isSuspiciousActivityNearby = false
    @Published var isCloseToSuspiciousActivity = false
    
    private let suspiciousActivityRadius: CLLocationDistance = 3_218.69 // 2 miles in meters
    
    private var reportedSuspiciousActivityLocation: CLLocation? // Location of the reported suspicious activity
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lastKnownLocation = location // Update the last known location
            checkSuspiciousActivity(location: location)
        }
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

