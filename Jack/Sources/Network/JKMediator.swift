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
    static func fetchBusiness(ids: Array<Int>, success: @escaping (Array<JKBusiness>) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.ids] = "\(ids)"
        
        JKNetwork.shared.query(path: "business", method: .get, parameters: params, success: { json in
            do {
                var businesses: Array<JKBusiness> = Array<JKBusiness>()
                
                let businessDict = json.dictionaryObject![JKKeys.businesses]
                let array = (businessDict as! Array<[String: Any]>)
                
                for value in array {
                    businesses.append(try JKBusiness.init(args: value))
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

        JKNetwork.shared.query(path: "business/area", method: .get, parameters: params, success: { json in
            do {
                var businesses: Array<JKBusiness> = Array<JKBusiness>()

                let businessDict = json.dictionaryObject![JKKeys.businesses]
                let array = (businessDict as! Array<[String: Any]>)

                for value in array {
                    businesses.append(try JKBusiness.init(args: value))
                }
                success(businesses)
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    // Fetch business products
    static func fetchBusinessProducts(id: Int, success: @escaping (Array<JKProduct>) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.id] = id
        
        JKNetwork.shared.query(path: "business/product/", method: .get, parameters: params, success: { json in
            do {
                var products: Array<JKProduct> = Array<JKProduct>()
                
                let productsDict = json.dictionaryObject![JKKeys.products]
                let array = (productsDict as! Array<[String: Any]>)
                
                for value in array {
                    products.append(try JKProduct.init(args: value))
                }
                success(products)
            } catch {
                failure()
            }
        }, failure: failure)
    }
    
    // Create business request
    static func createBusiness(name: String, address: String, type: String, description: String, success: @escaping (Int) -> Void, failure: @escaping () -> Void) {
        var params: [String: Any] = [:]
        
        params[JKKeys.name] = name
        params[JKKeys.address] = address
        params[JKKeys.type] = type
        params[JKKeys.description] = description
        
        JKNetwork.shared.query(path: "business/create", method: .post, parameters: params, success: { json in
            print("IDDDDDDD   \(json)")
            print("IDDDDDDD   \(json.description)")
            if let id = json.dictionaryObject?["id"] as? Int {
                print("IDDDDDDD   \(id)")
                success(id)
            }
            else {
                failure()
            }
        }, failure: failure)
    }
    
}
