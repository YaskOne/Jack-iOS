//
//  RegisterViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 8/7/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var signUpEmail: UITextField!
    @IBOutlet weak var signUpName: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.handleKeyboardVisibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        guard let user = JKSession.shared.user else {
            return
        }
        signUpEmail.text = user.email
        signUpName.text = user.name
    }

    @IBOutlet weak var signUpButton: AUButton!
    
    @IBAction func signUpTapped(_ sender: Any) {
        signUpButton.isEnabled = false
        JKMediator.updateUser(id: JKSession.shared.userId, name: signUpName.text, email: signUpEmail.text, password: signUpPassword.text, success: {
            self.navigationController?.popViewController(animated: true)
            self.signUpButton?.isEnabled = true
            }, failure: {
            self.signUpButton.isEnabled = true
        })
    }
}
//
//class RegisterViewController: UIViewController {
//
//    @IBOutlet weak var pageControl: UIPageControl?
////    @IBOutlet weak var containerView: UIView!
//
//    var pageViewController: APageViewController? {
//        didSet {
//            pageViewController?.pageDelegate = self
//            pageControl?.numberOfPages = (pageViewController?.pages.count)!
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        pageControl?.currentPage = 0
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "RegisterPageViewController" {
//            if let pageController = segue.destination as? APageViewController {
//                self.pageViewController = pageController
//            }
//        }
//    }
//
//}
//
//extension RegisterViewController: APageViewControllerDelegate {
//    func pageChanged(index: Int) {
//        pageControl?.currentPage = index
//    }
//}
