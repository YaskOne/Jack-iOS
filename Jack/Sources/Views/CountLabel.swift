//
//  CountLabel.swift
//  Jack
//
//  Created by Arthur Ngo Van on 12/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit

class CountLabel: UILabel {

    var count: Int = 0 {
        didSet {
            text = "x\(String(count))"
        }
    }

}
