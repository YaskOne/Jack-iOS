//
//  OrderViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 11/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

class OrderViewController: UIViewController {
    
    var orderViewController: OrderTableViewController?

    @IBOutlet weak var safeAreaTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderButton: JKButton!
    
    @IBOutlet weak var nameLabel: UILabel?
    
    lazy var popController = {
        return APopoverViewController()
    }()

    var place: JKBusiness? {
        didSet {
            if let place = place {
                nameLabel?.text = place.location.name
                orderViewController?.menu = place.categories
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        safeAreaTopConstraint.constant = UIApplication.shared.statusBarFrame.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func orderButtonTapped(_ sender: Any) {
        guard let source = orderViewController?.source else {
            return
        }
        var orders: [ATableViewRow] = []
        
        for item in source {
            if let product = item.object as? JKProduct, product.orderCount != 0 {
                orders.append(item)
            }
        }
        
        guard let controller = placeStoryboard.instantiateViewController(withIdentifier: "OrderOverviewViewController") as? OrderOverviewViewController else {
            return
        }
        
        popController.setUp(view: view, frame: view.frame, controller: controller)

        self.present(popController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OrderSegue") {
            orderViewController = segue.destination as? OrderTableViewController
            if let place = place {
                orderViewController?.menu = place.categories
//                orderViewController?.delegate = self
                nameLabel?.text = place.location.name
            }
        }
    }
}
