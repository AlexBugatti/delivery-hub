//
//  DeliveryService.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import UIKit

class DeliveryService: NSObject {

    static let shared = DeliveryService()
    
    private lazy var shops: [ShopModel] = {
        var shops = ShopResponse.all()
        return shops
    }()
    
    func generateOffer() -> Offer {
        let shop = shops[Int.random(in: 0..<shops.count)]
        let cost = Int.random(in: 100...10000)
        let time = Double(Int.random(in: 600...80400))
        let timestamp = Date().timeIntervalSince1970 + time
        
        let offer = Offer(timestamp: timestamp, shop: shop, cost: cost)
        return offer
    }
    
}

struct Offer {
    var timestamp: Double
    var shop: ShopModel
    var cost: Int
}
