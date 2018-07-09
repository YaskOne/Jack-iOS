//
//  LocationsGenerator.swift
//  Jack
//
//  Created by Arthur Ngo Van on 06/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import Foundation

class DataGenerator {
    
    static let shared = DataGenerator()
    
    var urls: [String] = [
        "https://mk0tainsights9mcv7wv.kinstacdn.com/wp-content/uploads/2018/01/premiumforrestaurants_0.jpg",
        "http://paris.peninsula.com/fr/~/media/Images/Paris/NEW/dining/loiseau-blanc/ppr-oiseau-blanc-interior-evening-1074.ashx?mw=952",
        "https://cdn-image.foodandwine.com/sites/default/files/1501607996/opentable-scenic-restaurants-marine-room-FT-BLOG0818.jpg",
        "https://paymentweek.com/wp-content/uploads/2018/03/opentable-scenic-restaurants-bertrand-at-mister-a-FT-BLOG0818-1024x576.jpg",
        "http://www.magaweb.fr/wp-content/uploads/2017/12/resto.jpg",
        "http://923754a44bec557e7a04-c27bd7765020b85ba1f12dac6c8e911a.r82.cf1.rackcdn.com/lps/assets/u/HD-The-Carolina-Room--1-.jpg",
        "https://d1vp8nomjxwyf1.cloudfront.net/wp-content/uploads/sites/64/2016/04/07101403/Manotel-Geneve-Restaurants.jpg",
        "https://mk0tainsights9mcv7wv.kinstacdn.com/wp-content/uploads/2018/01/premiumforrestaurants_0.jpg",
        "https://www.orbyhusgolf.se/wp-content/uploads/2018/01/Mat.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsmd2TD36rLl43-XoqCDzYjtQZNYewKfl5XeilYJVrlQCg1j-C",
        "http://lobu.hu/upload/upimages/32561.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXA6qCrXMybBrqDFGkUDhF4YlPv4F01_HzF1oJOnXbPvG-F8cf",
        "http://i.espectaculos.televisa.com/2017/06/famosos-y-restaurantes.jpg",
        "http://www.aljamila.com/sites/default/files/styles/ph2_1000_auto/public/2015/09/08/16-resto.jpg?itok=VxAtxxb4",
        "http://lefooding.com/media/W1siZiIsIjIwMTYvMDcvMTgvMTRfMzJfMjZfNTk0X2Jhcl9oYXJyeXNfbmV3X3lvcmtfYmFyX3BhcmlzLmpwZyJdLFsicCIsInRodW1iIiwiNjcyeDYwMCJdXQ/bar-harrys-new-york-bar-paris.jpg?sha=3a132a68",
        "http://www.blogenbois.fr/wp-content/uploads/2013/04/harrys-bar-paris-2.jpeg",
        "https://imgs.dm.com.br/uploads/2018/01/bar.jpg",
        "https://media.timeout.com/images/100454701/image.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQctMLFL3_SgqIWl41a4ALVxNv5URmCGHih1jQKnOPsVbj7irTl",
        "https://www.my-vb.com/img/assets/articles/img_bar-big.jpg",
        "http://blog.lecarnetdesbars.fr/wp-content/uploads/2015/09/harrys-bar-paris.jpg",
    ]
    
    var names: [String] = [
        "Mai do",
        "L'orangerie",
        "Epicure",
        "NE/SO",
        "Mystery cuisine",
        "Le vent d'amour",
        "Mu mi",
        "Sur mesure",
        "L'abeille",
        "Frenchie restaurant",
        "Ramen bowl",
        "Le 23",
        "Le Reminet",
        "Vin et Marée",
    ]
    
    var category: [String] = [
        "Francais",
        "Japonais",
        "Bar a vin",
        "Bar a bierre",
        "Bar a coctail",
        "Italien",
        "Grec",
        "Americain",
        "Peruvien",
    ]
    
    var descriptions: [String] = [
        "Francais super mega cool",
        "Japonais authentique dans son cadre chaleureux",
        "Bar a vin du terroir",
        "Bar a bierre, grosse rapta assuree",
        "Bar a coctail, ya tout",
        "Italien spaghetti et boulettes",
        ]
    
    var ordersDescriptions: [String] = [
        "Manioc et patate douce cuits dans des feuilles de bétel et servis dans du lait de coco",
        "Salade de boeuf mariné dans son jus de citron, échalote et feuille de menthe",
        "Emincés de poulet cuit dans sa feuille de Pandan",
        "Emincés de poulet au curry rouge et lait de coco",
        "Gambas sur plaque chauffante a la sauce noix de coco et curry",
        "Riz gluant au lait de coco et mangue fraîche",
        "Salade 'collection' de betteraves, fromage de chèvre et pistache",
        "Tiradito de lomo : filet de boeuf mariné au jus de citron, gingembre, oignon rouge, coriandre et céleri",
        "Ceviche de gambas, marinées au jus de fruits de la passion",
        "Carne : viande de bœuf, poivron rouge, oignon nouveau, cumin",
        "Carne picante : viande de bœuf, poivron rouge, oignon, piment rouge, aji molido",
        "CordobeSa : viande de bœuf, poivron rouge, oignon, raisins secs et olives vertes",
        "Copa clasico : glace vanille, glace dulce de leche, sauce chocolat, sauce dulce de leche, praline",
        "Copa Don Pedro : glace vanille, whisky, kumquat confit et praline",
        ]
    
    var foodCategories: [JKCategory] = [
        JKCategory.init(id: 0, name: "Entrees"),
        JKCategory.init(id: 1, name: "Poke"),
        JKCategory.init(id: 2, name: "Bruscetta"),
    ]
    
    func fetchFoodCategories(ids: [Int]) -> [Int: JKCategory] {
        var res: [Int: JKCategory] = [:]
        for id in ids {
            res[id] = foodCategories[id]
        }
        return res
    }
    
    func fetchProduct(ids: [Int]) -> [Int: JKProduct] {
        var res: [Int: JKProduct] = [:]
        for id in ids {
            res[id] = products[id]
        }
        return res
    }
    
    lazy var products: [JKProduct] = [
        JKProduct.init(id: 0, url: urls[0], name: "Salade verte", category: 0, description: ordersDescriptions[0], price: 5.00),
        JKProduct.init(id: 1, url: urls[1], name: "Salade betraves", category: 0, description: ordersDescriptions[1], price: 5.00),
        JKProduct.init(id: 2, url: urls[2], name: "Salade savoyarde", category: 0, description: ordersDescriptions[2], price: 5.00),
        JKProduct.init(id: 3, url: urls[3], name: "Salade poulet", category: 0, description: ordersDescriptions[3], price: 5.00),
        JKProduct.init(id: 4, url: urls[4], name: "Poke bowl", category: 1, description: ordersDescriptions[4], price: 5.00),
        JKProduct.init(id: 5, url: urls[5], name: "Poke thon", category: 1, description: ordersDescriptions[5], price: 5.00),
        JKProduct.init(id: 6, url: urls[6], name: "Poke saumon", category: 1, description: ordersDescriptions[6], price: 5.00),
        JKProduct.init(id: 7, url: urls[7], name: "Poke boeuf", category: 1, description: ordersDescriptions[7], price: 5.00),
        JKProduct.init(id: 8, url: urls[8], name: "Bruscetta bowl", category: 2, description: ordersDescriptions[8], price: 10.00),
        JKProduct.init(id: 9, url: urls[9], name: "Bruscetta thon", category: 2, description: ordersDescriptions[9], price: 10.00),
        JKProduct.init(id: 10, url: urls[10], name: "Bruscetta saumon", category: 2, description: ordersDescriptions[10], price: 10.00),
        JKProduct.init(id: 11, url: urls[11], name: "Bruscetta boeuf", category: 2, description: ordersDescriptions[11], price: 10.00),
    ]

    lazy var places: [Int: JKPlace] = {
        return placesGenerator()
    }()
    
    var locations: [JKLocation] {
        return places.values.map{return $0.location}
    }
    
    init() {
        
    }
    
    // 49.7 / 0.8
    // 47.7 / 4.3
    func placesGenerator() -> [Int: JKPlace] {
        var places: [Int: JKPlace] = [:]
        
        let categories: [JKCategory: [JKProduct]] = [
            foodCategories[0]: [products[0],products[1],products[2],products[3]],
            foodCategories[1]: [products[4],products[5],products[6],products[7]],
            foodCategories[2]: [products[8],products[9],products[10],products[11]],
            ]
        
        var i: Int = 0
        while i < 10000 {
            let lat = drand48() * 2 + 47.7
            let lng = drand48() * 3.5 + 0.8
            let url = urls[Int(arc4random_uniform(UInt32(urls.count)))]
            let name = names[Int(arc4random_uniform(UInt32(names.count)))]
            let type = category[Int(arc4random_uniform(UInt32(descriptions.count)))]
            let description = descriptions[Int(arc4random_uniform(UInt32(descriptions.count)))]
            let id = i
            
            let location = JKLocation.init(id: id, lat: lat, lng: lng, url: url, name: name, type: type)

            i=i+1;
            places[id] = JKPlace.init(location: location, categories: categories, description: description)
        }
        return places
    }
    
    func locationsInBoundaries(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Array<JKLocation> {
        var res = Array<JKLocation>()
        
        for location in locations {
            if location.lat > lat1 && location.lat < lat2 && location.lng > lng1 && location.lng < lng2 {
                res.append(location)
            }
            if res.count > 10 {
                break
            }
        }
        
        return res
    }
}
