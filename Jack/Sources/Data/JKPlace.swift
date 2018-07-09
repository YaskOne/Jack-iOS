//
//  JKPlace.swift
//  Jack
//
//  Created by Arthur Ngo Van on 08/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

class JKPlace {

    var id: Int
    
    var location: JKLocation
    var categories: [JKCategory: [JKProduct]]
    
    var description: String?
    
    init(location: JKLocation, categories: [JKCategory: [JKProduct]], description: String) {
        self.id = location.id

        self.location = location
        self.categories = categories
        
        self.description = description
    }
    
}
