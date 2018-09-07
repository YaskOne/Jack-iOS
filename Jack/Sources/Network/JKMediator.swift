//
//  JKMediator.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/6/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import Foundation
import UIKit
import JackModel
import SwiftyJSON

class JKMediator {
    
    // Fetch business request
    static func fetchBusiness(ids: Array<UInt>, success: @escaping (Array<JKBusiness>) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.ids] = "\(ids)"
        
        let _ = JKNetwork.shared.query(path: "business/", method: .get, parameters: params, success: { json in
            do {
                var businesses: Array<JKBusiness> = Array<JKBusiness>()
                
                guard let array = json.dictionaryObject?[JKKeys.businesses] as? Array<[String: Any]> else {
                    failure()
                    return
                }
                
                for value in array {
                    let business = try JKBusiness.init(args: value)
                    JKBusinessCache.shared.addObject(id: business.id, object: business)
                    businesses.append(business)
                }
                success(businesses)
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    // Fetch visible business request
    static func fetchBusiness(boundaries: JKBoundaries, success: @escaping (Array<JKBusiness>) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]

        params[JKKeys.nearLeftLatitude] = boundaries.nearLeft.latitude
        params[JKKeys.nearLeftLongitude] = boundaries.nearLeft.longitude
        params[JKKeys.farRightLatitude] = boundaries.farRight.latitude
        params[JKKeys.farRightLongitude] = boundaries.farRight.longitude

        let _ = JKNetwork.shared.query(path: "business/area", method: .get, parameters: params, success: { json in
            do {
                var businesses: Array<JKBusiness> = Array<JKBusiness>()

                guard let array = json.dictionaryObject?[JKKeys.businesses] as? Array<[String: Any]> else {
                    failure()
                    return
                }

                for value in array {
                    let business = try JKBusiness.init(args: value)
                    JKBusinessCache.shared.addObject(id: business.id, object: business)
                    businesses.append(business)
                }
                success(businesses)
            } catch {
                failure()
            }
        }, failure: failure)
    }

    // Fetch business stockes
    static func fetchBusinessStocks(id: UInt, success: @escaping ([UInt: [UInt]]) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.id] = id
        
        let _ = JKNetwork.shared.query(path: "business/stocks/", method: .get, parameters: params, success: { json in
            do {
                var newCategories: [UInt: [UInt]] = [:]
                
                let categoriesDict = json.dictionaryObject![JKKeys.stocks]
                
                guard let categoryArray = (categoriesDict as? Array<[String: Any]>) else {
                    failure()
                    return
                }
                
                for category in categoryArray {
                    let newCategory = try JKCategory.init(args: category)
                    var newProducts: Array<UInt> = Array<UInt>()
                    
                    JKCategoryCache.shared.addObject(id: newCategory.id, object: newCategory)
                    if let products = category[JKKeys.products] as? [[String: Any]], products.count != 0 {
                        for product in products {
                            let newProduct = try JKProduct.init(args: product)
                            newProducts.append(newProduct.id)
                            JKProductCache.shared.addObject(id: newProduct.id, object: newProduct)
                        }
                        newCategories[newCategory.id] = newProducts
                    }
                }
                success(newCategories)
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    // Create business request
    static func createBusiness(email: String, name: String, password: String, address: String, type: String, description: String, url: String, success: @escaping (Int) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.email] = email
        params[JKKeys.name] = name
        params[JKKeys.password] = password
        params[JKKeys.address] = address
        params[JKKeys.type] = type
        params[JKKeys.description] = description
        params[JKKeys.url] = url
        
        let _ = JKNetwork.shared.query(path: "business/create", method: .post, parameters: params, success: { json in
            if let id = json.dictionaryObject?["id"] as? Int {
                success(id)
            }
            else {
                failure()
            }
        }, failure: failure)
    }
    
    // Create product request
    static func createProduct(name: String, price: Float, category: UInt, url: String, businessId: UInt, success: @escaping (Int) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.name] = name
        params[JKKeys.price] = price
        params[JKKeys.categoryId] = category
        params[JKKeys.url] = url
        params[JKKeys.businessId] = businessId
        
        let _ = JKNetwork.shared.query(path: "business/product/create", method: .post, parameters: params, success: { json in
            if let id = json.dictionaryObject?["id"] as? Int {
                success(id)
            }
            else {
                failure()
            }
        }, failure: failure)
    }
    
    // Create product request
    static func createCategory(name: String, businessId: UInt, success: @escaping (Int) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.name] = name
        params[JKKeys.businessId] = businessId
        
        let _ = JKNetwork.shared.query(path: "business/category/create", method: .post, parameters: params, success: { json in
            if let id = json.dictionaryObject?["id"] as? Int {
                success(id)
            }
            else {
                failure()
            }
        }, failure: failure)
    }
    
    // Create product request
    static func createOrder(retrieveDate: Date, productIds: Array<UInt>, userId: UInt, businessId: UInt, success: @escaping (Int) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.retrieveDate] = retrieveDate.getISO8601()
        params[JKKeys.productIds] = productIds
        params[JKKeys.userId] = userId
        params[JKKeys.businessId] = businessId
        
        let _ = JKNetwork.shared.query(path: "business/order/create", method: .post, parameters: params, success: { json in
            if let id = json.dictionaryObject?["id"] as? Int {
                success(id)
            }
            else {
                failure()
            }
        }, failure: failure)
    }
    
    // Fetch business stockes
    static func fetchOrders(businessId: UInt? = nil, userId: UInt? = nil, success: @escaping ([JKOrder]) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        if let businessId = businessId {
            params[JKKeys.businessId] = businessId
        }
        if let userId = userId {
            params[JKKeys.userId] = userId
        }
        
        let _ = JKNetwork.shared.query(path: "order", method: .get, parameters: params, success: { json in
            do {
                var orders: [JKOrder] = []
                
                guard let array = json.dictionaryObject?[JKKeys.orders] as? Array<[String: Any]> else {
                    failure()
                    return
                }
                
                for order in array {
                    let newOrder = try JKOrder.init(args: order)
                    
                    JKOrderCache.shared.addObject(id: newOrder.id, object: newOrder)
                    //                    JKProductCache.shared.addObject(id: newOrder.id, object: newOrder)
                    orders.append(newOrder)
                }
                success(orders)
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    // Fetch products
    static func fetchProducts(ids: [UInt]? = nil, businessId: UInt? = nil, categoryId: UInt? = nil, success: @escaping (Array<JKProduct>) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        if let ids = ids {
            params[JKKeys.ids] = "\(ids)"
        } else if let businessId = businessId {
            params[JKKeys.businessId] = businessId
        } else if let categoryId = categoryId {
            params[JKKeys.categoryId] = categoryId
        }
        
        let _ = JKNetwork.shared.query(path: "product/", method: .get, parameters: params, success: { json in
            do {
                var products: Array<JKProduct> = Array<JKProduct>()
                
                guard let array = json.dictionaryObject?[JKKeys.products] as? Array<[String: Any]> else {
                    failure()
                    return
                }
                
                for value in array {
                    let product = try JKProduct.init(args: value)
                    products.append(product)
                    JKProductCache.shared.addObject(id: product.id, object: product)
                }
                success(products)
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    // Fetch categories
    static func fetchCategories(ids: [UInt]? = nil, businessId: UInt? = nil, success: @escaping (Array<JKCategory>) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        if let ids = ids {
            params[JKKeys.ids] = "\(ids)"
        } else if let businessId = businessId {
            params[JKKeys.businessId] = businessId
        }
        
        let _ = JKNetwork.shared.query(path: "category/", method: .get, parameters: params, success: { json in
            do {
                var categories: Array<JKCategory> = Array<JKCategory>()
                
                guard let array = json.dictionaryObject?[JKKeys.categories] as? Array<[String: Any]> else {
                    failure()
                    return
                }
                
                for value in array {
                    let category = try JKCategory.init(args: value)
                    categories.append(category)
                    JKCategoryCache.shared.addObject(id: category.id, object: category)
                }
                success(categories)
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    static func logBusiness(email: String, password: String, success: @escaping (JKBusiness) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.email] = email
        params[JKKeys.password] = password
        
        let _ = JKNetwork.shared.query(path: "business/log", method: .get, parameters: params, success: { json in
            do {
                guard let args = json.dictionaryObject?[JKKeys.business] as? [String: Any] else {
                    failure()
                    return
                }
                
                success(try JKBusiness.init(args: args))
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    static func logUser(email: String, password: String, success: @escaping (JKUser) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.email] = email
        params[JKKeys.password] = password
        
        let _ = JKNetwork.shared.query(path: "user/log", method: .get, parameters: params, success: { json in
            do {
                guard let args = json.dictionaryObject?[JKKeys.user] as? [String: Any] else {
                    failure()
                    return
                }
                
                success(try JKUser.init(args: args))
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    static func createUser(name: String, email: String, password: String, success: @escaping (UInt) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.name] = name
        params[JKKeys.email] = email
        params[JKKeys.password] = password
        
        let _ = JKNetwork.shared.query(path: "user/create", method: .post, parameters: params, success: { json in
            guard let id = json.dictionaryObject?[JKKeys.id] as? UInt else {
                failure()
                return
            }
            
            success(id)
        }, failure: failure)
    }
    
    static func fetchUsers(ids: [UInt], success: @escaping (Array<JKUser>) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.ids] = ids
        
        let _ = JKNetwork.shared.query(path: "user/", method: .get, parameters: params, success: { json in
            do {
                var users: Array<JKUser> = Array<JKUser>()
                
                guard let array = json.dictionaryObject?[JKKeys.users] as? Array<[String: Any]> else {
                    failure()
                    return
                }
                
                for value in array {
                    let user = try JKUser.init(args: value)
                    users.append(user)
                }
                success(users)
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    static func updateOrder(orderId: UInt, userId: UInt, status: String? = nil, state: String? = nil, canceled: Bool? = nil, success: @escaping () -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.orderId] = orderId
        params[JKKeys.userId] = userId
        
        if let status = status {
            params[JKKeys.status] = status
        }
        if let state = state {
            params[JKKeys.state] = state
        }
        if let canceled = canceled {
            params[JKKeys.canceled] = canceled
        }
        
        let _ = JKNetwork.shared.query(path: "order/update", method: .post, parameters: params, success: { json in
            do {
                guard let data = json.dictionaryObject else {
                    failure()
                    return
                }
                
                let order = try JKOrder.init(args: data)
                
                JKOrderCache.shared.addObject(id: order.id, object: order)
                
                success()
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    static func deleteUserAccount(userId: UInt, success: @escaping () -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.id] = userId
        
        let _ = JKNetwork.shared.query(path: "user/delete", method: .post, parameters: params, success: { json in
            success()
        }, failure: failure)
    }
    
    static func deleteBusinessAccount(businessId: UInt, success: @escaping () -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.id] = businessId
        
        let _ = JKNetwork.shared.query(path: "business/delete", method: .post, parameters: params, success: { json in
            success()
        }, failure: failure)
    }
    
    static func updateUser(id: UInt, name: String? = nil, email: String? = nil, password: String? = nil, success: @escaping () -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.id] = id
        if let name = name {
            params[JKKeys.name] = name
        }
        if let email = email {
            params[JKKeys.email] = email
        }
        if let password = password {
            params[JKKeys.password] = password
        }
        
        let _ = JKNetwork.shared.query(path: "user/update", method: .post, parameters: params, success: { json in
            do {
                guard let data = json.dictionaryObject?[JKKeys.user] as? [String: Any] else {
                    failure()
                    return
                }
                
                let user = try JKUser.init(args: data)
                
                JKUserCache.shared.addObject(id: user.id, object: user)
                
                success()
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    // Create business request
    static func updateBusiness(id: UInt, email: String? = nil, name: String? = nil, password: String? = nil, address: String? = nil, type: String? = nil, description: String? = nil, url: String? = nil, success: @escaping () -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.id] = id
        if let email = email {
            params[JKKeys.email] = email
        }
        if let name = name {
            params[JKKeys.name] = name
        }
        if let password = password {
            params[JKKeys.password] = password
        }
        if let address = address {
            params[JKKeys.address] = address
        }
        if let type = type {
            params[JKKeys.type] = type
        }
        if let description = description {
            params[JKKeys.description] = description
        }
        if let url = url {
            params[JKKeys.url] = url
        }
        
        let _ = JKNetwork.shared.query(path: "business/update", method: .post, parameters: params, success: { json in
            do {
                guard let data = json.dictionaryObject?[JKKeys.business] as? [String: Any] else {
                    failure()
                    return
                }
                
                let business = try JKBusiness.init(args: data)
                
                JKBusinessCache.shared.addObject(id: business.id, object: business)
                
                success()
            } catch {
                failure()
            }
        }, failure: failure)
    }
}

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        //        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}
