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
    
    let defaults: UserDefaults = {
        return UserDefaults.standard
    }()
    
    var lastPos: CLLocation?
    
    var order: JKBuildOrder?
    
    var userId: UInt = 0
    var user: JKUser? {
        get {
            return JKUserCache.shared.getItem(id: userId)
        }
        set {
            if let newValue = newValue {
                userId = newValue.id
                JKUserCache.shared.addObject(id: newValue.id, object: newValue)
            }
        }
    }
    
    func startSession() {
        if let lat = defaults.object(forKey: JKKeys.latitude) as? CLLocationDegrees, let lng = defaults.object(forKey: JKKeys.longitude) as? CLLocationDegrees {
            lastPos = CLLocation.init(latitude: lat, longitude: lng)
        }
        
        if let id = defaults.object(forKey: JKKeys.userId) as? UInt {
            userId = id
            loadUser()
        }
    }
    
    func saveSession() {
        let defaults = UserDefaults.standard

        defaults.set(lastPos?.coordinate.latitude, forKey: JKKeys.latitude)
        defaults.set(lastPos?.coordinate.longitude, forKey: JKKeys.longitude)

        defaults.set(userId, forKey: JKKeys.userId)
    }

    func closeSession() {
        JKUserCache.shared.removeObject(id: userId)
        defaults.set(0, forKey: JKKeys.userId)
        userId = 0
    }
    
    func loadUser() {
        JKUserCache.shared.loadInCache(ids: [userId])
    }
}
