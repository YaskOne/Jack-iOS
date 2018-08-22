//
//  JKSession.swift
//  Jack
//
//  Created by Arthur Ngo Van on 6/27/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import Foundation
import CoreLocation
import JackModel

class JKSession {
    
    static let shared = JKSession()
    
    var lastPos: CLLocation?
    
    var order: JKBuildOrder?
    
    func startSession() {
        let defaults = UserDefaults.standard
        
        if let lat = defaults.object(forKey: JKKeys.latitude) as? CLLocationDegrees, let lng = defaults.object(forKey: JKKeys.longitude) as? CLLocationDegrees {
            lastPos = CLLocation.init(latitude: lat, longitude: lng)
        }
        
    }
    
    func closeSession() {
        let defaults = UserDefaults.standard

        defaults.set(lastPos?.coordinate.latitude, forKey: JKKeys.latitude)
        defaults.set(lastPos?.coordinate.longitude, forKey: JKKeys.longitude)

    }
    
}
