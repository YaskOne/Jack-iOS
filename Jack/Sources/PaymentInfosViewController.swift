//
//  PaymentInfosViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 9/9/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import Stripe

class PaymentInfosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapped(_ sender: Any) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        navigationController?.pushViewController(addCardViewController, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func sectapped(_ sender: Any) {
//        let customerContext = STPCustomerContext(keyProvider: STPEphemeralKeyProvider.)
//
//        // Setup payment methods view controller
//        let paymentMethodsViewController = STPPaymentMethodsViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default(), customerContext: customerContext, delegate: self)
//
//        // Present payment methods view controller
//        let navigationController = UINavigationController(rootViewController: paymentMethodsViewController)
//        present(navigationController, animated: true)
    }
    
    @IBAction func thirdtapped(_ sender: Any) {
        let shippingAddressViewController = STPShippingAddressViewController()
        shippingAddressViewController.delegate = self
        
        // Present shipping address view controller
        let navigationController = UINavigationController(rootViewController: shippingAddressViewController)
        present(navigationController, animated: true)
    }
}

extension PaymentInfosViewController: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {

        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        navigationController?.popViewController(animated: true)
    }
}

extension PaymentInfosViewController: STPShippingAddressViewControllerDelegate {
    func shippingAddressViewControllerDidCancel(_ addressViewController: STPShippingAddressViewController) {
        
    }
    
    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didEnter address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        
    }
    
    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didFinishWith address: STPAddress, shippingMethod method: PKShippingMethod?) {
        
    }
    
    
}
