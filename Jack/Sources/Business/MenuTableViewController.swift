//
//  ProductsTableViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 08/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

struct ProductItem {
    var product: JKProduct?
    var category: JKCategory?
}

let overviewController = UIStoryboard(name: "Place", bundle: nil).instantiateViewController(withIdentifier: "ProductOverviewViewController") as! ProductOverviewViewController

protocol ModifyOrderDelegate {
    func addItem(item: JKProduct)
    func removeItem(item: JKProduct)
}

class MenuTableViewController: ATableViewController {
    
    override var topInset: CGFloat {
        return 60
    }
    
    override var cellIdentifiers: [ARowType: String] {
        return [
            .header: "PlaceHeaderCell",
            .section: "CategoryCell",
            .row: "ProductOrderCell",
        ]
    }
    
    override var cellHeights: [ARowType: CGFloat] {
        return [
            .header: 250,
            .section: 40,
            .row: 70,
        ]
    }
    
    lazy var popController = {
        return APopoverViewController()
    }()
    
    var place: JKBusiness? {
        didSet {
            if let place = place {
                menu = place.categories
            }
        }
    }
    
    var menu: [JKCategory: [JKProduct]] = [:] {
        didSet {
            var section = 0
            source = []
            source.append(ATableViewRow.init(type: .header, section: -1, object: nil))
            for item in menu {
                source.append(ATableViewRow.init(type: .section, section: section, object: ATableViewSection.init(name: item.key.name)))
                for product in item.value {
                    source.append(ATableViewRow.init(type: .row, section: section, object: product))
                }
            }
            section += 1
        }
    }
    
    var delegate: ModifyOrderDelegate?
    
    override func setUpRow(item: ATableViewRow, indexPath: IndexPath) -> UITableViewCell {
        let cell = super.setUpRow(item: item, indexPath: indexPath)
        
        cell.selectionStyle = .none
        
        if let cell = cell as? ProductOrderCell, let product = item.object as? JKProduct {
            cell.product = product
            cell.delegate = delegate
        }
        return cell
    }

    override func setUpHeader(item: ATableViewRow, indexPath: IndexPath) -> UITableViewCell {
        let cell = super.setUpHeader(item: item, indexPath: indexPath)
        
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        
        if let cell = cell as? PlaceHeaderCell, let place = place {
            cell.backgroundImageView.imageFromURL(urlString: place.location.url)
            cell.nameLabel.text = place.location.name
            cell.backgroundTopConstraint.constant = -(topInset + UIApplication.shared.statusBarFrame.height)
            if JKSession.shared.order == nil {
                cell.alertLabel.isHidden = false
            }
        }
        
        return cell
    }
    
    override func setUpSection(item: ATableViewRow, indexPath: IndexPath) -> UITableViewCell {
        let cell = super.setUpSection(item: item, indexPath: indexPath)

        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        
        if let cell = cell as? CategoryCell, let object = item.object as? ATableViewSection {
            cell.titleLabel?.text = object.name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = (itemAtIndex(indexPath).object as? JKProduct)?.id else {
            return
        }
        
        popController.setUp(view: view, frame: view.frame, controller: overviewController)
        overviewController.id = id
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
        popController.popoverRatio = 1
    }
    
}

class CategoryCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
}

class ProductOrderCell: UITableViewCell {
    
    var delegate: ModifyOrderDelegate?
    
    var product: JKProduct? {
        didSet {
            nameLabel?.text = product?.name ?? ""
            priceLabel?.price = product?.price ?? 0
            if let url = product?.url {
                JKImageLoader.loadImage(imageView: productImageView, url: url) {}
            }
            else {
                productImageView?.image = nil
            }
        }
    }
    
    @IBOutlet weak var productImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var priceLabel: PriceLabel?
    
    @IBOutlet weak var orderOverview: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    var orderCount: Int = 0 {
        didSet {
            countLabel.text = "x\(orderCount)"
        }
    }
    
    @IBAction func addItemTapped(_ sender: Any) {
        orderCount += 1
        if let product = product {
            delegate?.addItem(item: product)
        }
    }
    
    @IBAction func removeItemTapped(_ sender: Any) {
        orderCount -= 1
        if let product = product {
            delegate?.removeItem(item: product)
        }
    }
}

class PlaceHeaderCell: UITableViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var alertLabel: UILabel!
}
