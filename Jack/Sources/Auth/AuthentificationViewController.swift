//
//  AuthentificationViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 8/29/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

class AuthentificationViewController: UIViewController {

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
        
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        }, failure: {})
    }
    
    @IBAction func acceptCguTapped(_ sender: Any) {
        cguButton.isSelected = !cguButton.isSelected
        cguButton.borderColor = cguButton.isSelected ? UIColor.green : UIColor.darkGray
        cguButton.titleLabel?.textColor = cguButton.isSelected ? UIColor.green : UIColor.darkGray
    }
    
    @IBAction func cguTapped(_ sender: Any) {
        navigationController?.pushViewController(homeStoryboard.instantiateViewController(withIdentifier: "CGU"), animated: true)
    }
    
    @IBOutlet weak var signUpButton: AUButton!
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard
            let email = signUpEmail.text,
            let name = signUpName.text,
            cguButton.isSelected,
            let password = signUpPassword.text else {
                return
        }
        
        signUpButton.isEnabled = false
        JKMediator.createUser(name: name, email: email, password: password, success: { id in
            
            JKMediator.logUser(email: email, password: password, success: { user in
                JKSession.shared.user = user
                self.navigationController?.popViewController(animated: true)
                self.signUpButton.isEnabled = true
            }, failure: {})
        }, failure: {
            self.signUpButton.isEnabled = true
        })
    }
}
