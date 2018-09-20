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
    
    var delegate: AuthentificationDelegate?
    
    @IBOutlet weak var signUpEmail: AULabeledTextField!
    @IBOutlet weak var signUpName: AULabeledTextField!
    @IBOutlet weak var signUpPassword: AULabeledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.handleKeyboardVisibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user = JKSession.shared.user else {
            return
        }
        signUpEmail.text = user.email
        signUpName.text = user.name
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func cguTapped(_ sender: Any) {
        navigationController?.pushViewController(homeStoryboard.instantiateViewController(withIdentifier: "CGU"), animated: true)
    }

    @IBOutlet weak var signUpButton: AUButton!
    
    @IBAction func signUpTapped(_ sender: Any) {
        if let user = JKSession.shared.user {
            signUpButton.isEnabled = false
            JKMediator.updateUser(id: JKSession.shared.userId, name: signUpName.text, email: signUpEmail.text, password: signUpPassword.text, success: {
                self.navigationController?.popViewController(animated: true)
                self.signUpButton?.isEnabled = true
            }, failure: {
                self.signUpButton.isEnabled = true
            })
        } else {
            guard
                let email = signUpEmail.text,
                let name = signUpName.text,
                let password = signUpPassword.text else {
                    return
            }
            
            signUpButton.isEnabled = false
            JKMediator.createUser(name: name, email: email, password: password, success: { id in
                
                JKMediator.logUser(email: email, password: password, success: { user in
                    JKSession.shared.user = user
                    self.signUpButton.isEnabled = true
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.userLogged()
                }, failure: {})
            }, failure: {
                self.signUpButton.isEnabled = true
            })
        }
    }
}
