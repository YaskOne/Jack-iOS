//
//  ALocationManager.swift
//  Jack
//
//  Created by Arthur Ngo Van on 06/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

protocol JKLocationManagerProtocol {
    func userLocationChanged()
}

public class JKLocationManager: UIViewController, CLLocationManagerDelegate {
    
    static let shared = JKLocationManager()
    
    let locationManager = CLLocationManager()
    
    var lastLocation: CLLocation?
    
    var delegate: JKLocationManagerProtocol?
    
    public func setUp() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = manager.location
//        if let lastLocation = lastLocation {
//            print("locations = \(lastLocation.latitude) \(lastLocation.longitude)")
//        }
        delegate?.userLocationChanged()
    }
}
