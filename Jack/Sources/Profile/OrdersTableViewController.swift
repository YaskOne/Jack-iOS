//
//  OrdersTableViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 8/29/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

protocol OrderSelectDelegate {
    func orderSelected(order: JKOrder)
}

class OrdersTableViewController: ATableViewController {
    
    var delegate: OrderSelectDelegate?
    
    override var cellIdentifiers: [ARowType: String] {
        return [
            .header: "",
            .section: "",
            .row: "OrderTableCell",
        ]
    }
    
    override var cellHeights: [ARowType: CGFloat] {
        return [
            .header: 0,
            .section: 0,
            .row: 110,
        ]
    }
    
    var orders: [JKOrder] = [] {
        didSet {
            source = []
            orders.sort() { $0.pickupDate > $1.pickupDate }
            for item in orders {
                source.append(ATableViewRow.init(type: .row, section: 0, object: item))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUp() {
        if let id = JKSession.shared.user?.id {
            JKMediator.fetchOrders(userId: id, success: {orders in
                self.orders = orders
                
                JKBusinessCache.shared.loadInCache(ids: orders.map{return $0.businessId})
            }, failure: {
                
            })
        }
    }
    
    override func setUpRow(item: ATableViewRow, indexPath: IndexPath) -> UITableViewCell {
        let cell = super.setUpRow(item: item, indexPath: indexPath)
        
        cell.selectionStyle = .none
        
        if let cell = cell as? OrderTableCell, let order = item.object as? JKOrder {
            cell.order = order
            cell.controller = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let order = (itemAtIndex(indexPath).object as? JKOrder) else {
            return
        }
        
        delegate?.orderSelected(order: order)
    }
    
}

class OrderTableCell: UITableViewCell {
    
    var controller: UIViewController?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: AULabel!
    @IBOutlet weak var countdownView: CountdownView!
    @IBOutlet weak var cancelButton: AUButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    var order: JKOrder? {
        didSet {
            if let order = order {
                nameLabel.text = JKBusinessCache.shared.getItem(id: order.businessId)?.name
                countdownView.value = order.pickupDate.minutesSinceNow()
                countLabel.args = [
                    "count": String(order.productIds.count),
                    "price": order.price
                ]
                statusLabel.text = order.canceled ? "CANCELED" : "\(order.status.rawValue.uppercased()),\(order.state.rawValue.uppercased())"
                countdownView.textColor = UIColor.black
                cancelButton.isHidden = order.status != .PENDING || order.canceled
                NotificationCenter.default.removeObserver(self, name: userChangedNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(objectUpdated), name: businessChangedNotification, object: nil)
            }
        }
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let alert = UIAlertController(title: AULocalized.string("cancel_order_title"), message: AULocalized.string("confirm_cancel_order"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: AULocalized.string("confirm_action"), style: .default, handler: { action in
            if let order = self.order {
                JKMediator.updateOrder(orderId: order.id, userId: order.userId, canceled: true, success: {
                    if let order = self.order {
                        self.order = JKOrderCache.shared.getItem(id: order.id)
                    }
                }, failure: {})
            }
        }))
        alert.addAction(UIAlertAction(title: AULocalized.string("cancel_action"), style: .default, handler: { action in
        }))
        controller?.present(alert, animated: true, completion: nil)
    }
    
    @objc func objectUpdated(notif: Notification) {
        if let id = notif.userInfo?["id"] as? UInt, id == order?.businessId {
            nameLabel.text = JKBusinessCache.shared.getItem(id: id)?.name
        }
    }
}
