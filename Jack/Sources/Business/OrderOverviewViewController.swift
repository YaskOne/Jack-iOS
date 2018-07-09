//
//  OrderOverview.swift
//  Jack
//
//  Created by Arthur Ngo Van on 12/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit

class OrderOverviewViewController: UIViewController {
    
    @IBOutlet weak var pickupTimeLabel: UILabel!
    @IBOutlet weak var totalCountLabel: PriceLabel!
    
    var orderOverviewViewController: OrderOverviewTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickupTimeLabel.text = "Commande a recuperer dans \(JKSession.shared.order!.pickupDelay)"
        totalCountLabel.price = JKSession.shared.order?.price ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OrderOverviewSegue") {
            orderOverviewViewController = segue.destination as? OrderOverviewTableViewController
            orderOverviewViewController?.rawSource = JKSession.shared.order?.categories ?? [:]
        }
    }

    @IBAction func finalizeOrderTapped(_ sender: Any) {
        dismiss(animated: true, completion: {
            // send request
        })
    }
    
}
