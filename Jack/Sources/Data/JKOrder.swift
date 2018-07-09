//
//  JKOrder.swift
//  Jack
//
//  Created by Arthur Ngo Van on 12/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import Foundation

class JKOrder {
    
    var restaurantId: Int = -1
    var pickupDate: Date

    var categories: [JKCategory: [JKProduct]] = [:]
    
    var price: Float {
        var count: Float = 0
        
        for category in categories {
            for product in category.value {
                count += Float(product.orderCount) * product.price
            }
        }
        return count
    }
    
    var pickupDelay: String {
        let timeIntervalSinceNow = pickupDate.timeIntervalSinceNow
        let hoursSinceNow = Int(timeIntervalSinceNow / 3600)
        let minutesSinceNow = Int((Int(timeIntervalSinceNow) - (hoursSinceNow * 3600)) / 60)

        return "\(hoursSinceNow)h\(minutesSinceNow)"
    }
    
    init(pickupDate: Date) {
        self.pickupDate = pickupDate
    }
    
}
