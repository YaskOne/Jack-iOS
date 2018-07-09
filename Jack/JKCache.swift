//
//  JKCache.swift
//  Jack
//
//  Created by Arthur Ngo Van on 11/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit

struct JKCacheItem {
    var object: AnyObject
    var timestamp: Double
}

class JKIdCache {
    
    var cache: [Int: JKCacheItem] = [:]
    
    func addObject(id: Int, object: AnyObject) {
        cache[id] = JKCacheItem.init(object: object, timestamp: 0)
    }
    
}

class JKStringCache {
    
    var cache: [String: JKCacheItem] = [:]
    
    func addObject(key: String, object: AnyObject) {
        cache[key] = JKCacheItem.init(object: object, timestamp: 0)
    }
    
}

class JKImageCache: JKStringCache {
    
    static let shared: JKImageCache = JKImageCache()
    
    func getObject(key: String) -> UIImage? {
        return cache[key]?.object as? UIImage
    }
    
}
