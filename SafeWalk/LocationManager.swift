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
    
    public func requestLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        completion?(location)
        self.lastKnownLocation = location
        LocationManager.shared.lastKnownLocation = location
        manager.stopUpdatingLocation()
    }
}
