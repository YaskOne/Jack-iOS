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
        JKNetwork.shared.server = "http://127.0.0.1:3000"
        JKNetwork.shared.server = "https://imb1l2wde1.execute-api.eu-west-2.amazonaws.com/Prod"
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        let controller = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        let controller = authStoryboard.instantiateViewController(withIdentifier: "APageViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
}

