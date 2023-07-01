//
//  LocationManager.swift
//  SafeWalk
//
//  Created by Riyad Sarsour on 6/26/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    @Published var lastKnownLocation: CLLocation?
    var completion: ((CLLocation) -> Void)?
    
    @Published var isSuspiciousActivityNearby = false
    @Published var isCloseToSuspiciousActivity = false
        
    private let suspiciousActivityRadius: CLLocationDistance = 3_218.69 // 2 miles in meters
        
    private var reportedSuspiciousActivityLocation: CLLocation? // Location of the reported suspicious activity
        
    
    public func requestLocation(completion: @escaping ((CLLocation) -> Void)) {
        manager.delegate = self
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        
        manager.startUpdatingLocation()
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        //completion?(location)
        self.lastKnownLocation = location
        print(location)
        LocationManager.shared.lastKnownLocation = location
        //manager.stopUpdatingLocation()
    }
}
