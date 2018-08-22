//
//  ProductOverviewViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 11/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import JackModel

class ProductOverviewViewController: UIViewController {
    
    var id: UInt = 0 {
        didSet {
            product = JKProductCache.shared.getItem(id: id)
            setUp()
        }
    }
    
    var product: JKProduct?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setUp() {
        if let product = product {
            JKImageLoader.loadImage(imageView: imageView, url: product.url) {}
            nameLabel.text = product.name
            descriptionLabel.text = product.description
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
