//
//  UserProfileViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 15/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setUp), name: businessChangedNotification, object: nil)
        navigationController?.setNavigationBarHidden(true, animated: true)

        setUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: userChangedNotification, object: nil)
    }
    
    @objc func setUp() {
        surnameLabel.text = JKSession.shared.user?.name
        emailLabel.text = JKSession.shared.user?.email
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOut(_ sender: Any) {
        JKSession.shared.closeSession()
        
        let vc = authStoryboard.instantiateViewController(withIdentifier: "AuthentificationViewController") as? AuthentificationViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func deleteAccountTapped(_ sender: Any) {

        AUAlertController.shared.simpleAlertController(
            self,
            title: AULocalized.string("delete_account_action"),
            message: AULocalized.string("confirm_delete_account_title"),
            success: {
                JKMediator.deleteUserAccount(userId: JKSession.shared.userId, success: {
                    NotificationCenter.default.post(name: changePageNotification, object: nil, userInfo: ["page": 1])
                    JKSession.shared.closeSession()
                }, failure: {
                    
                })
        }, error: {
            
        })
    }
    
    @IBAction func cguTapped(_ sender: Any) {
        navigationController?.pushViewController(homeStoryboard.instantiateViewController(withIdentifier: "CGU"), animated: true)
    }
    
    @IBAction func editProfileTapped(_ sender: Any) {
        navigationController?.pushViewController(authStoryboard.instantiateViewController(withIdentifier: "RegisterViewController"), animated: true)
    }
    
}

