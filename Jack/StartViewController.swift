//
//  StartViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 7/5/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
let placeStoryboard = UIStoryboard(name: "Place", bundle: nil)
let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        
        AUToastController.shared.container = view
        
        let controller = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(controller, animated: false)
        
        if JKSession.shared.userId != 0 {
            NotificationCenter.default.post(name: userLoggedNotification, object: nil, userInfo: nil)
        }
    }
    
}

