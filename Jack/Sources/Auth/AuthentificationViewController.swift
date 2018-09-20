//
//  AuthentificationViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 8/29/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import Stripe

protocol AuthentificationDelegate {
    func userLogged()
}

class AuthentificationViewController: UIViewController {
    
    var delegate: AuthentificationDelegate?

    @IBOutlet weak var logInEmail: UITextField!
    @IBOutlet weak var logInPassword: UITextField!

    @IBOutlet weak var signUpEmail: UITextField!
    @IBOutlet weak var signUpName: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    @IBOutlet weak var cguButton: AUButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.handleKeyboardVisibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        
//        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func cheatTapped(_ sender: Any) {
        JKMediator.logUser(email: "arthur.ngovan@gmail.com", password: "arthurarthur", success: { user in
            JKSession.shared.user = user
            self.navigationController?.popViewController(animated: true)
        }, failure: {})
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        guard
            let email = logInEmail.text,
            let password = logInPassword.text else {
            return
        }
        
        JKMediator.logUser(email: email, password: password, success: { user in
            JKSession.shared.user = user
            self.navigationController?.popViewController(animated: true)
            self.delegate?.userLogged()
        }, failure: {})
    }
    
    @IBOutlet weak var signUpButton: AUButton!
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let vc = authStoryboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {
            return
        }
        
        vc.delegate = delegate
        navigationController?.replaceCurrentViewController(with: vc, animated: true)
    }
    
    
}
