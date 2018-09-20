//
//  OrdersViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 8/29/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import JackModel
import ArtUtilities

class OrdersViewController: UIViewController {

    var orderTable: OrdersTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orderTable?.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        orderTable?.setUp()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OrderTableSegue") {
            orderTable = segue.destination as? OrdersTableViewController
            orderTable?.delegate = self
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
    }
    
}
extension OrdersViewController: OrderSelectDelegate {
    
    func orderSelected(order: JKOrder) {
        let vc = homeStoryboard.instantiateViewController(withIdentifier: "OrderInfosViewController") as! OrderInfosViewController
        vc.order = order
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
