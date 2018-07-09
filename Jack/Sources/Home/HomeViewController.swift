//
//  ViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 28/05/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

let mapTappedNotification = Notification.Name("mapTappedNotification")
let openLocationNotification = Notification.Name("openLocationNotification")
let openLocationOverviewNotification = Notification.Name("openLocationOverviewNotification")

class HomeViewController: APresenterViewController {
    
    @IBOutlet weak var mapContainer: UIView!
    
    @IBOutlet weak var safeArea: UIView!
    @IBOutlet weak var safeAreaTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pickTimeButton: JKButton!
    
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
    
    var mapController: MapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init location manager singleton
        JKLocationManager.shared.setUp()
        JKLocationManager.shared.delegate = self
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        safeAreaTopConstraint.constant = UIApplication.shared.statusBarFrame.height
        
        registerNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MapViewController,
            segue.identifier == "MapSegue" {
            mapController = vc
        }
    }
    
    @IBAction func locateUserTapped(_ sender: Any) {
        if let location = JKLocationManager.shared.lastLocation {
            mapController?.flyToLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
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
        if let id = notif.userInfo?["id"] as? Int {
            guard let controller = placeStoryboard.instantiateViewController(withIdentifier: "PlaceViewController") as? PlaceViewController else {
                return
            }
            controller.placeId = id
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func openLocationOverview(notif: Notification) {
        if let id = notif.userInfo?["id"] as? Int {
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

extension HomeViewController {
    
    func registerNotifications() {
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

extension HomeViewController: JKLocationManagerProtocol {
    func userLocationChanged() {
        JKSession.shared.lastPos = JKLocationManager.shared.lastLocation
    }
}

extension HomeViewController: TimePickerDelegate {
    func timePicked(date: Date) {
        let timeIntervalSinceNow = date.timeIntervalSinceNow
        let hoursSinceNow = Int(timeIntervalSinceNow / 3600)
        let minutesSinceNow = Int((Int(timeIntervalSinceNow) - (hoursSinceNow * 3600)) / 60)

        pickupTimeLabel.text = "Restaurants disponibles dans \(hoursSinceNow)h\(minutesSinceNow)"
        hasSelectedPickupTime = true

        JKSession.shared.order = JKOrder.init(pickupDate: date)
    }
}
