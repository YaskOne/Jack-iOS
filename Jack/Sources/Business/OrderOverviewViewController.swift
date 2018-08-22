//
//  OrderOverview.swift
//  Jack
//
//  Created by Arthur Ngo Van on 12/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

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
            orderOverviewViewController?.rawSource = JKSession.shared.order?.extendedProducts ?? []
        }
    }

    @IBAction func finalizeOrderTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        JKMediator.createOrder(
            retrieveDate: JKSession.shared.order!.pickupDate,
            productIds: Array<UInt>(JKSession.shared.order!.extendedProducts.map{$0.id}),
            userId: 1,
            businessId: JKSession.shared.order!.restaurantId,
            success: {_ in
                print("Success")
        },
            failure: {
                print("Error")
        })
        
        self.present(controller, animated: true, completion: nil)
    }
    
}
