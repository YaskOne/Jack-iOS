//
//  JKNetwork.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/6/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class JKNetwork {
    
    static var shared: JKNetwork = JKNetwork()
    
    var server: String?
    
    public func query(path: String, method: HTTPMethod, queue: DispatchQueue = DispatchQueue.main, skipLog: Bool = false, parameters: Parameters? = nil, success: @escaping (JSON) -> Void, failure: @escaping () -> Void) -> String? {
        
        var paramsEncoding: ParameterEncoding = URLEncoding.default
        
        if method == HTTPMethod.post || method == HTTPMethod.put {
            paramsEncoding = JSONEncoding.default
        }
        else if method == HTTPMethod.delete {
            paramsEncoding = URLEncoding.queryString
        }
        
        var headers = HTTPHeaders()
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["authorization"] = "allow"
        
        print("----------------------------- Request: \(path)")
        print("  - parameters: \(String(describing: parameters))")
        Alamofire
            .request(server! + "/" + path, method: method, parameters: parameters, encoding: paramsEncoding, headers: headers)
            .responseJSON { response in
                
                do {
                    var json = try JSON(data: response.data!)
                    
                    if let error = json.dictionaryObject?["error"] {
                        print("Error: \(path)")
                        print("  - message: \(error)")
                    }
                    else {
                        print("Success: \(path)")
                    }
                    
                    success(json)
                } catch {
                    failure()
                }
        }
        
        return ""
    }
}
