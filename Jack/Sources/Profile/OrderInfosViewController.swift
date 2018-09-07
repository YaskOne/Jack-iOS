//
//  OrderOverviewViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 9/6/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import JackModel
import ArtUtilities

class OrderInfosViewController: UIViewController {

    var orderTable: OrderProductsTableViewController?
    
    @IBOutlet weak var businessLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?
    @IBOutlet weak var commandLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var stateLabel: UILabel?
    
    @IBOutlet weak var countdownView: CountdownView?
    
    var order: JKOrder? {
        didSet {
            setUp()
        }
    }
    
    func setUp() {
        guard let order = order, let business = JKBusinessCache.shared.getItem(id: order.businessId) else {
            return
        }
        
        let date = order.pickupDate.formatDate(dateFormat: "yyyy-MM-dd")
        let time = order.pickupDate.formatDate(dateFormat: "HH:mm")
        
        businessLabel?.text = business.name
        addressLabel?.text = business.address
        commandLabel?.text = "Total de la commande: \(order.price)€"
        dateLabel?.text = "Le \(date), à \(time)"
        countdownView?.value = order.pickupDate.minutesSinceNow()
        countdownView?.textColor = UIColor.darkGray
        stateLabel?.text = order.canceled ? JKOrderState.CANCELED.rawValue : order.state.rawValue
        
        orderTable?.productIds = order.productIds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUp()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OrderProductsTableSegue") {
            orderTable = segue.destination as? OrderProductsTableViewController
            if let products = order?.productIds {
                orderTable?.productIds = products
            }
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        orderTable?.setUp()
    }
}
extension OrderInfosViewController: OrderSelectDelegate {
    
    func orderSelected(order: JKOrder) {
        
    }
    
}
