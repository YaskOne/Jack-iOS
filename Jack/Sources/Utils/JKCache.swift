//
//  JKCache.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 8/26/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import Foundation
import JackModel

let businessChangedNotification = Notification.Name("businessChangedNotification")
let productChangedNotification = Notification.Name("productChangedNotification")
let userChangedNotification = Notification.Name("userChangedNotification")
let orderChangedNotification = Notification.Name("orderChangedNotification")

open class JKBusinessCache: JKIdCache {
    
    public override init() {
        super.init()
        
        notification = businessChangedNotification
    }
    
    public static let shared: JKBusinessCache = JKBusinessCache()
    
    public func getItem(id: UInt) -> JKBusiness? {
        return cache[id]?.object as? JKBusiness
    }
    
    public func loadInCache(ids: [UInt]) {
        let newIds = removeKnownIds(ids: ids)
        
        JKMediator.fetchBusiness(ids: newIds, success: { businesses in
            for business in businesses {
                self.addObject(id: business.id, object: business)
            }
        }, failure: {})
    }
}
open class JKProductCache: JKIdCache {
    
    public static let shared: JKProductCache = JKProductCache()
    
    public func getItem(id: UInt) -> JKProduct? {
        return cache[id]?.object as? JKProduct
    }
    
    public func loadInCache(ids: [UInt]) {
        let newIds = removeKnownIds(ids: ids)
        
        JKMediator.fetchProducts(ids: newIds, success: { products in
            for product in products {
                self.addObject(id: product.id, object: product)
            }
        }, failure: {})
    }
}
open class JKCategoryCache: JKIdCache {
    
    public static let shared: JKCategoryCache = JKCategoryCache()
    
    public func getItem(id: UInt) -> JKCategory? {
        return cache[id]?.object as? JKCategory
    }
    
    public func loadInCache(ids: [UInt]) {
        let newIds = removeKnownIds(ids: ids)
        
        JKMediator.fetchCategories(ids: newIds, success: { categories in
            for category in categories {
                self.addObject(id: category.id, object: category)
            }
        }, failure: {})
    }
}
open class JKUserCache: JKIdCache {
    
    public override init() {
        super.init()
        
        notification = userChangedNotification
    }
    
    public static let shared: JKUserCache = JKUserCache()
    
    public func getItem(id: UInt) -> JKUser? {
        return cache[id]?.object as? JKUser
    }
    
    public func loadInCache(ids: [UInt]) {
        let newIds = removeKnownIds(ids: ids)
        
        JKMediator.fetchUsers(ids: newIds, success: { users in
            for user in users {
                self.addObject(id: user.id, object: user)
            }
        }, failure: {})
    }
}
open class JKOrderCache: JKIdCache {
    
    public static let shared: JKOrderCache = JKOrderCache()
    
    public func getItem(id: UInt) -> JKOrder? {
        return cache[id]?.object as? JKOrder
    }
    
    public override init() {
        super.init()
        
        notification = orderChangedNotification
    }
}
