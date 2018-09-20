//
//  ViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 28/05/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

let changePageNotification = Notification.Name("changePageNotification")

class HomeViewController: UIViewController {
    
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var dashboardButton: UIButton!
    @IBOutlet weak var shopButton: UIButton!
    
    var menu: [UIButton] {
        return [
            statsButton,
            dashboardButton,
            shopButton,
        ]
    }
    var currentPage: Int = 0 {
        didSet {
            menu[oldValue].isSelected = false
            menu[currentPage].isSelected = true
            pageViewController?.currentIndex = currentPage
        }
    }
    
    var pageViewController: AUPageViewController? {
        didSet {
            pageViewController?.pageDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = 1
        NotificationCenter.default.addObserver(self, selector: #selector(self.pageChangedHandler), name: changePageNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "HomePageViewController" {
            if let pageController = segue.destination as? AUPageViewController {
                self.pageViewController = pageController
                pageViewController?.removeSwipeGesture()
                pageViewController?.pages = [
                    homeStoryboard.instantiateViewController(withIdentifier: "OrdersViewController"),
                    homeStoryboard.instantiateViewController(withIdentifier: "MapViewController"),
                    homeStoryboard.instantiateViewController(withIdentifier: "UserProfileViewController")
                ]
                pageViewController?.currentIndex = 1
            }
        }
    }
    
    @IBAction func statsTapped(_ sender: Any) {
        if !userLogged() {
            return
        }
        currentPage = 0
    }
    
    @IBAction func dashboardTapped(_ sender: Any) {
        currentPage = 1
    }
    
    @IBAction func shopTapped(_ sender: Any) {
        if !userLogged() {
            return
        }
        currentPage = 2
    }
    
    func userLogged() -> Bool {
        if let _ = JKSession.shared.user {
            return true
        } else {
            if let controller = authStoryboard.instantiateViewController(withIdentifier: "AuthentificationViewController") as? AuthentificationViewController {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        return false
    }
    
    @objc func pageChangedHandler(notif: Notification) {
        if let page = notif.userInfo?["page"] as? Int {
            currentPage = page
        }
    }
}

extension HomeViewController: AUPageViewControllerDelegate {
    func pageChanged(index: Int) {
    }
}
