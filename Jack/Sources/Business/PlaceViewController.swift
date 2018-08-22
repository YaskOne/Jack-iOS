//
//  PlaceViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 07/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import JackModel

class PlaceViewController: UIViewController {
    
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navBackground: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var orderButton: JKButton?
    
    @IBOutlet weak var safeAreaTopConstraint: NSLayoutConstraint!
    
    var menuViewController: MenuTableViewController?
//
//    var orders: [UInt: JKProduct] {
//        return JKSession.shared.order?.products ?? [:]
//    }
    
    lazy var popController = {
        return APopoverViewController()
    }()
    
    var placeId: UInt = 0 {
        didSet {
            place = JKBusinessCache.shared.getItem(id: placeId)
            if place != nil {
                JKMediator.fetchBusinessStocks(id: placeId, success: { (stocks) in
                    self.place?.categories = stocks
                    if let menuViewController = self.menuViewController {
                        menuViewController.place = self.place
                    }
                }, failure: {})
            }
        }
    }
    
    var place: JKBusiness? {
        didSet {
            setUp()
        }
    }
    
    var navBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height + navBar.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        nameLabel?.text = place?.location.name ?? ""
        safeAreaTopConstraint.constant = UIApplication.shared.statusBarFrame.height
    }

    func setUp() {
        if let place = place {
            menuViewController?.place = place
        }
        
        JKSession.shared.order = JKBuildOrder.init(pickupDate: Date())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func orderTapped(_ sender: Any) {
//        var orders: [ATableViewRow] = []
//
//        for item in source {
//            if let product = item.object as? JKProduct, product.orderCount != 0 {
//                orders.append(item)
//            }
//        }
        
        guard let controller = placeStoryboard.instantiateViewController(withIdentifier: "OrderOverviewViewController") as? OrderOverviewViewController else {
            return
        }
        
        popController.setUp(view: view, frame: view.frame, controller: controller)
        
        self.present(popController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MenuSegue") {
            menuViewController = segue.destination as? MenuTableViewController
            menuViewController?.place = place
            menuViewController?.scrollDelegate = self
            menuViewController?.delegate = self
        }
    }
    
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0

    var lastLocation: CGPoint = CGPoint.zero
    var velocity: CGFloat = 0
    
    var headerHeight: CGFloat {
        return (menuViewController?.cellHeights[.header] ?? 0) - navBarHeight
    }
    
    func handleDragVelocity() {
        startTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.02,
                                     target: self,
                                     selector: #selector(advanceTimer(timer:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func advanceTimer(timer: Timer) {
        let increased = min(headerHeight, max(0, (menuViewController?.tableView.contentOffset.y)! + velocity / 2))
        
        print("Increased \(increased)")
        menuViewController?.tableView.contentOffset.y = increased
        if increased == headerHeight || increased == 0 {
            self.timer?.invalidate()
        }
    }
}

extension PlaceViewController: ATableViewScrollDelegate {
    
    func tableWillEndDragging(offset: CGFloat, velocity: CGFloat) {
        guard
            let headerHeight = menuViewController?.cellHeights[.header],
            let tableOffset = menuViewController?.tableView.contentOffset.y,
            tableOffset < headerHeight else {
            return
        }

        DispatchQueue.main.async {
            self.menuViewController?.tableView.scrollToRow(at: IndexPath.init(row: velocity >= 0 ? 1 : 0, section: 0), at: .top, animated: true)
        }
    }
    
    func tableWillScroll() {
        self.timer?.invalidate()
    }
    
    func tableDidScroll(offset: CGFloat) {
        guard let headerHeight = menuViewController?.cellHeights[.header],
            let cell = menuViewController?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? PlaceHeaderCell else {
            return
        }
        
        let ratio = offset >= (headerHeight - navBarHeight) ? 1 : offset / (headerHeight - navBarHeight)

        navBar.alpha = ratio
        navBackground.alpha = ratio == 1 ? 1 : 0
        cell.overlayView.alpha = ratio
    }
}

extension PlaceViewController: ModifyOrderDelegate {
    
    func addItem(item: JKProduct) {
        if let order = JKSession.shared.order {
            let productOrder = JKProductOrder.init(product: item)
            if order.products[item.id] == nil {
                order.products[item.id] = [:]
            }
            order.products[item.id]?[productOrder.orderId] = productOrder
        }
    }
    
    func removeItem(item: JKProduct) {
        if let order = JKSession.shared.order, let items = order.products[item.id] {
            if items.count > 1, let index = order.products[item.id]?.first?.value.orderId {
                order.products[item.id]?.removeValue(forKey: index)
            } else {
                order.products.removeValue(forKey: item.id)
            }
        }
    }
    
}
