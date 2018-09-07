//
//  JKWebViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 9/4/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import Foundation
import UIKit

class JKWebViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        self.title = "CGU"
        
        if let url = URL(string: "https://jack-world.com/conditions-generales-dutilisation/") {
            do {
                let cgu = try String.init(contentsOf: url)
                webView?.loadHTMLString(cgu, baseURL: nil)
            }
            catch {
                
            }
        }
    }
    
}
