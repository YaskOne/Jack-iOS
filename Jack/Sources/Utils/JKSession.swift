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
import Stripe

let userLoggedNotification = Notification.Name("userLoggedNotification")

class JKSession {
    
    static let shared = JKSession()
    
    var fcmToken: String?
    var token: String?
    
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
                userLogged()
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
        NotificationCenter.default.addObserver(self, selector: #selector(userLogged), name: userLoggedNotification, object: nil)
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
    
    @objc func userLogged() {
        JKMediator.updateUser(id: userId, fcmToken: fcmToken, success: {}, failure: {})
    }
    
    func isLogged(delegate: AuthentificationDelegate? = nil) -> Bool {

        if JKSession.shared.user == nil {
            if let controller = authStoryboard.instantiateViewController(withIdentifier: "AuthentificationViewController") as? AuthentificationViewController {
                controller.delegate = delegate
                UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
            }
            return false
        }
        return true
    }
        
    func isPaymentAuthorized(delegate: STPAddCardViewControllerDelegate) -> Bool {
        if let user = JKSession.shared.user, user.stripeCustomerId.isEmpty, let vc = delegate as? UIViewController {
            
            let addCardViewController = STPAddCardViewController()
            addCardViewController.delegate = delegate
            
            vc.navigationController?.setNavigationBarHidden(false, animated: true)
            vc.navigationController?.pushViewController(addCardViewController, animated: true)
            return false
        }
        return true
    }
}
