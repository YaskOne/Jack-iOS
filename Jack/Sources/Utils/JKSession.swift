//
//  JKSession.swift
//  Jack
//
//  Created by Arthur Ngo Van on 6/27/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import Foundation
import CoreLocation

class JKSession {
    
    static let shared = JKSession()
    
    var lastPos: CLLocation?
    
    var order: JKOrder?
    
    func startSession() {
        let defaults = UserDefaults.standard
        
        if let lat = defaults.object(forKey: JKKeys.lat) as? CLLocationDegrees, let lng = defaults.object(forKey: JKKeys.lng) as? CLLocationDegrees {
            lastPos = CLLocation.init(latitude: lat, longitude: lng)
        }
        
    }
    
    func closeSession() {
        let defaults = UserDefaults.standard

        defaults.set(lastPos?.coordinate.latitude, forKey: JKKeys.lat)
        defaults.set(lastPos?.coordinate.longitude, forKey: JKKeys.lng)

    }
    
}
