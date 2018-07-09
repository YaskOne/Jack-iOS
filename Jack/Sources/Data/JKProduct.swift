//
//  JKProduct.swift
//  Jack
//
//  Created by Arthur Ngo Van on 08/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import Foundation

class JKProduct {
    var id: Int
    var url: String
    var name: String
    var category: Int
    var description: String
    var price: Float
    var orderCount: Int = 0
    
    init(id: Int, url: String, name: String, category: Int, description: String, price: Float) {
        self.id = id
        self.url = url
        self.name = name
        self.category = category
        self.description = description
        self.price = price
    }
}

struct JKPromotion: Codable {
    
}

struct JKCategory: Codable, Hashable {
    var id: Int
    var name: String
}
