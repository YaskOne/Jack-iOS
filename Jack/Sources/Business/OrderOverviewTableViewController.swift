//
//  FinalizeOrderTableViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 12/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

class OrderOverviewTableViewController: ATableViewController {
    
    override var cellIdentifiers: [ARowType: String] {
        return [
            .header: "PlaceHeaderCell",
            .section: "CategoryCell",
            .row: "OrderOverviewCell",
        ]
    }
    
    var place: JKBusiness?
    
    override var cellHeights: [ARowType: CGFloat] {
        return [
            .header: 250,
            .section: 40,
            .row: 30,
        ]
    }
    
    var rawSource: [JKProduct] = [] {
        didSet {
            var section = 0
            source = []
            for item in rawSource {
                source.append(ATableViewRow.init(type: .row, section: section, object: item))
            }
            section += 1
        }
    }

//    var rawSource: [JKTableViewRow] = [] {
//        didSet {
//            var lastSection = -1
//            source = []
//            for product in rawSource {
//                if lastSection != product.section {
//                    lastSection = product.section
////                    source.append(JKTableViewRow.init(type: .section, section: lastSection, object: JKTableViewSection.init(name: place!.categories.keys.[product.section])))
//                }
//                source.append(product)
//            }
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    override func setUpRow(item: ATableViewRow, indexPath: IndexPath) -> UITableViewCell {
        let cell = super.setUpRow(item: item, indexPath: indexPath)
        
        cell.selectionStyle = .none
        
        if let cell = cell as? OrderOverviewCell, let product = itemAtIndex(indexPath).object as? JKProduct {
            cell.product = product
        }

        return cell
    }
    
    override func setUpSection(item: ATableViewRow, indexPath: IndexPath) -> UITableViewCell {
        let cell = super.setUpSection(item: item, indexPath: indexPath)
        
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        
        if let cell = cell as? CategoryCell, let object = item.object as? ATableViewSection {
            cell.titleLabel?.text = object.name
            cell.titleLabel?.textColor = UIColor.black
        }
        
        return cell
    }
    
}

class OrderOverviewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var countLabel: CountLabel?
    @IBOutlet weak var priceView: PriceLabel?
    
    var product: JKProduct? {
        didSet {
            if let product = product {
                nameLabel?.text = product.name
                priceView?.price = product.price
            }
        }
    }
}
