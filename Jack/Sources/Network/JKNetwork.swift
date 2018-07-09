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
        
        print(server! + "/" + path)
        print(parameters?.description)
        Alamofire
            .request(server! + "/" + path, method: method, parameters: parameters, encoding: paramsEncoding, headers: headers)
            .responseJSON { response in
//                print("---- \(response.request)")  // original URL request
//                print("---- \(response.response)") // URL response
//                print("---- \(response.data)")     // server data
//                print("---- \(response.result)")   // result of response serialization

                do {
                    var json = try JSON(data: response.data!)
                
//                    print(json)
//                    print(json["places"][0])
//                    print(json["places"][0]["CreatedAt"])
                    success(json)
                } catch {
                    
                }
            }
        
        return ""
    }
}
