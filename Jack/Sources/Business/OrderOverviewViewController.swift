//
//  OrderOverview.swift
//  Jack
//
//  Created by Arthur Ngo Van on 12/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

protocol OrderCompletedDelegate {
    func orderCompleted()
}

class OrderOverviewViewController: UIViewController {
    
    @IBOutlet weak var pickupTimeLabel: AULabel!
    @IBOutlet weak var totalCountLabel: PriceLabel!
    
    var delegate: OrderCompletedDelegate?
    
    var orderOverviewViewController: OrderOverviewTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickupTimeLabel.args["minutes"] = "\(JKSession.shared.order!.pickupDate.minutesSinceNow())"
        totalCountLabel.price = JKSession.shared.order?.price ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OrderOverviewSegue") {
            orderOverviewViewController = segue.destination as? OrderOverviewTableViewController
            orderOverviewViewController?.rawSource = JKSession.shared.order?.extendedProducts ?? []
        }
    }

    @IBAction func finalizeOrderTapped(_ sender: Any) {
        JKMediator.createOrder(
            retrieveDate: JKSession.shared.order!.pickupDate,
            productIds: Array<UInt>(JKSession.shared.order!.extendedProducts.map{$0.id}),
            userId: JKSession.shared.user!.id,
            businessId: JKSession.shared.order!.businessId,
            success: {_ in
                print("Success")
        },
            failure: {
                print("Error")
        })
        
        self.dismiss(animated: true)
        delegate?.orderCompleted()
    }
    
}
