//
//  StartViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 7/5/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit

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
        
        let controller = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(controller, animated: false)
    }
    
//    @IBAction func buttonClick(_ sender: Any) {
//    }
//
//    @IBAction func registerClicked(_ sender: Any) {
//        let controller = authStoryboard.instantiateViewController(withIdentifier: "APageViewController")
//        navigationController?.pushViewController(controller, animated: true)
//    }
}

