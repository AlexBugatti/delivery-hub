//
//  ShopModel.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import UIKit

class ShopModel: Decodable {
    var id: Int
    var name: String
    var coordinate: Coordinate
    var city: String
    var street: String
}

struct ShopResponse: Decodable {
    var items: [ShopModel]
    
    static func all() -> [ShopModel] {
        
        guard let path = Bundle.main.url(forResource: "Shops", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: path, options: .mappedIfSafe)
            let result = try JSONDecoder().decode(ShopResponse.self, from: data)
            return result.items
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
}

class Coordinate: Decodable {
    var latitude: Double
    var longitude: Double
}
