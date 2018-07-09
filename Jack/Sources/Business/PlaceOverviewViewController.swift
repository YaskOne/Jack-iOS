//
//  PlaceOverviewViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 15/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

class PlaceOverviewViewController: APresentableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    var placeId: Int = 0 {
        didSet {
            place = DataGenerator.shared.places[placeId]
        }
    }
    var place: JKBusiness? {
        didSet {
            setUp()
        }
    }
    
    func setUp() {
        if let place = place {
            JKImageLoader.loadImage(imageView: profileImageView, url: place.location.url) {}
            titleLabel?.text = place.location.name
            descriptionLabel?.text = place.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openPlaceTapped)))
    }
    
    @objc func openPlaceTapped() {
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: openLocationNotification, object: nil, userInfo: ["id": placeId])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
