//
//  MapViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 8/29/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

let mapTappedNotification = Notification.Name("mapTappedNotification")
let openLocationNotification = Notification.Name("openLocationNotification")
let openLocationOverviewNotification = Notification.Name("openLocationOverviewNotification")

class MapViewController: APresenterViewController {
    
    @IBOutlet weak var mapContainer: UIView!
    
    @IBOutlet weak var safeArea: UIView!
    @IBOutlet weak var safeAreaTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pickTimeButton: AUButton!
    
    @IBOutlet weak var pickupTimeLabel: UILabel!
    @IBOutlet weak var pickupTimeContainer: UIView!
    
    var hasSelectedPickupTime: Bool {
        get {
            return JKSession.shared.order?.pickupDate != nil
        }
        set {
            pickupTimeContainer.isUserInteractionEnabled = newValue
            pickupTimeContainer.alpha = newValue ? 1 : 0
            pickTimeButton.isUserInteractionEnabled = !newValue
            pickTimeButton.alpha = !newValue ? 1 : 0
        }
    }
    
    var mapController: GoogleMapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init location manager singleton
        JKLocationManager.shared.setUp()
        JKLocationManager.shared.delegate = self
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        safeAreaTopConstraint.constant = UIApplication.shared.statusBarFrame.height
        registerNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        unregisterNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GoogleMapViewController,
            segue.identifier == "MapSegue" {
            mapController = vc
        }
    }
    
    @IBAction func locateUserTapped(_ sender: Any) {
        if let location = JKLocationManager.shared.lastLocation {
            mapController?.flyToLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        } else {
            mapController?.flyToLocation(lat: 48.861976, lng: 2.341345, zoom: 14)
        }
    }
    
    @IBAction func compassTapped(_ sender: Any) {
        mapController?.normalizeDirection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func mapTapped(notif: Notification) {
    }
    
    @objc func openLocation(notif: Notification) {
        if let id = notif.userInfo?["id"] as? UInt {
            guard let controller = placeStoryboard.instantiateViewController(withIdentifier: "PlaceViewController") as? PlaceViewController else {
                return
            }
            JKSession.shared.order = JKBuildOrder.init(pickupDate: Date().dateInMinutes(10), businessId: id)
            controller.placeId = id
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func openLocationOverview(notif: Notification) {
        if let id = notif.userInfo?["id"] as? UInt {
            guard let controller = homeStoryboard.instantiateViewController(withIdentifier: "PlaceOverviewViewController") as? PlaceOverviewViewController else {
                return
            }
            
            controller.modalPresentationStyle = UIModalPresentationStyle.custom
            controller.transitioningDelegate = self
            
            controller.placeId = id
            self.present(controller, animated: true, completion: nil)
        }
    }
    @IBAction func cancelPickupTimeTapped(_ sender: Any) {
        JKSession.shared.order = nil
        hasSelectedPickupTime = false
    }
    
    @IBAction func choosePickupItemTapped(_ sender: Any) {
        
        guard let controller = homeStoryboard.instantiateViewController(withIdentifier: "PickTimeViewController") as? PickTimeViewController else {
            return
        }
        
        controller.modalPresentationStyle = UIModalPresentationStyle.custom
        controller.transitioningDelegate = self
        controller.delegate = self
        
        self.present(controller, animated: true, completion: nil)
        //        if !isPickingTime {
        //            UIView.animate(withDuration: 0.35, animations: {
        //                self.isPickingTime = true
        //            }) { finished in
        //            }
        //        }
        //        else {
        //
        //        }
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        let pvc = homeStoryboard.instantiateViewController(withIdentifier: "UserProfileViewController") as UIViewController
        
        pvc.modalPresentationStyle = UIModalPresentationStyle.custom
        pvc.transitioningDelegate = self
        pvc.view.backgroundColor = UIColor.red
        
        self.present(pvc, animated: true, completion: nil)
    }
}

extension MapViewController {
    
    func registerNotifications() {
        unregisterNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(mapTapped), name: mapTappedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openLocation), name: openLocationNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openLocationOverview), name: openLocationOverviewNotification, object: nil)
    }
    
    func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: mapTappedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: openLocationNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: openLocationOverviewNotification, object: nil)
    }
}

extension MapViewController: JKLocationManagerProtocol {
    func userLocationChanged() {
        JKSession.shared.lastPos = JKLocationManager.shared.lastLocation
    }
}

extension MapViewController: TimePickerDelegate {
    func timePicked(date: Date) {
        let timeIntervalSinceNow = date.timeIntervalSinceNow
        let hoursSinceNow = Int(timeIntervalSinceNow / 3600)
        let minutesSinceNow = Int((Int(timeIntervalSinceNow) - (hoursSinceNow * 3600)) / 60)
        
        pickupTimeLabel.text = "Restaurants disponibles dans \(hoursSinceNow)h\(minutesSinceNow)"
        hasSelectedPickupTime = true
        
        //        JKSession.shared.order = JKBuildOrder.init(pickupDate: date, )
    }
}
