//
//  OrderProductsTableViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 9/6/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

class OrderProductsTableViewController: ATableViewController {
    
    override var cellIdentifiers: [ARowType: String] {
        return [
            .header: "",
            .section: "",
            .row: "OrderProductTableCell",
        ]
    }
    
    override var cellHeights: [ARowType: CGFloat] {
        return [
            .header: 0,
            .section: 0,
            .row: 50,
        ]
    }
    
    var productIds: [UInt] = [] {
        didSet {
            products = []
            if productIds.count != 0 {
                JKMediator.fetchProducts(ids: productIds, success: { products in
                    self.products = products
                }, failure: {
                    
                })
            }
        }
    }
    
    var products: [JKProduct] = [] {
        didSet {
            source = []
            for item in products {
                source.append(ATableViewRow.init(type: .row, section: 0, object: item))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func setUp() {
        //        JKMediator.fetchBusinessOrders(id: JKSession.shared.business!.id, success: {orders in
        //            self.orders = orders
        //        }, failure: {
        //
        //        })
    }
    
    override func setUpRow(item: ATableViewRow, indexPath: IndexPath) -> UITableViewCell {
        let cell = super.setUpRow(item: item, indexPath: indexPath)
        
        cell.selectionStyle = .none
        
        if let cell = cell as? OrderProductTableCell, let product = item.object as? JKProduct {
            cell.product = product
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

class OrderProductTableCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: AUImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var priceView: PriceLabel?
    
    var product: JKProduct? {
        didSet {
            clearFields()
            if let product = product {
                nameLabel?.text = product.name
                priceView?.price = product.price
                if product.url != "" {
                    JKImageLoader.loadImage(imageView: productImageView, url: product.url) {}
                }
                else {
                    productImageView?.image = nil
                }
            }
        }
    }
    
    func clearFields() {
        productImageView?.image = nil
        nameLabel?.text = nil
        priceView?.text = nil
    }
}
