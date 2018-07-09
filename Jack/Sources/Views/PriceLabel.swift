//
//  PriceView.swift
//  Jack
//
//  Created by Arthur Ngo Van on 12/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit

class PriceLabel: UILabel {
    
    var currency: String {
        return "€"
    }
    
    var price: Float = 0 {
        didSet {
            self.text = "\(price)\(currency)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    func setUp() {
    }
}
