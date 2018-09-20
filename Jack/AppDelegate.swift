//
//  AppDelegate.swift
//  Jack
//
//  Created by Arthur Ngo Van on 7/5/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import GoogleMaps
import ArtUtilities
import Firebase
import UserNotifications
import Stripe
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyC2IT49iFLikS_ZU7-8HHTt8nt1GCisaO0")
        JKNetwork.shared.server = "http://127.0.0.1:3000"
        
        // stage
        
        // prod
        //        JKNetwork.shared.server = "https://jq62zukmo5.execute-api.eu-west-2.amazonaws.com/Prod"
        
        // dev
        #if DEV
            JKNetwork.shared.server = "https://dke39nk4w3.execute-api.eu-west-2.amazonaws.com/Prod"
        #else
            JKNetwork.shared.server = "https://7qw9g2c1q4.execute-api.eu-west-2.amazonaws.com/Prod"
        #endif

        
        JKSession.shared.startSession()
        
        AUAlertController.shared.setUpDefault(defaultOk: "validate_action", defaultCancel: "cancel_action")

        STPPaymentConfiguration.shared().publishableKey = "pk_live_T9fYUMkeD7s89195iMdOC02C"

        Messaging.messaging().delegate = self
        FirebaseApp.configure()
        registerForPushNotifications()

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("device token : \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        guard let aps = userInfo["aps"] as? [String: Any],
            let alert = aps["alert"] as? [String: Any],
            let message = alert["body"] as? String else {
            return
        }

        let systemSoundID: SystemSoundID = 1016
        
        // to play sound
        AudioServicesPlaySystemSound (systemSoundID)
        AUToastController.shared.toast(text: message, type: ToastType.info)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        JKSession.shared.saveSession()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
        JKSession.shared.saveSession()
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        print("PUSH NOTIFS \(data)")
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("fcmToken \(fcmToken)")
        JKSession.shared.fcmToken = fcmToken
    }
    
}
