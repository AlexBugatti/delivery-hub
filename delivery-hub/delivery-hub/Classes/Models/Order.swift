//
//  Order.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import UIKit
import RealmSwift
import MapKit

enum OrderState: String {
    case active = "active"
    case cancelled = "canceled"
    case completed = "completed"
    
    var color: UIColor {
        switch self {
            case .active:
                return .orange
            case .cancelled:
                return .red
            case .completed:
                return .green
        }
    }
    var title: String {
        switch self {
            case .active:
                return "Активный"
            case .cancelled:
                return "Отклоненный"
            case .completed:
                return "Завершен"
        }
    }
}

class Order: Object {
    @Persisted var name: String = ""
    @Persisted var id: Int
    @Persisted var shopId: Int
    @Persisted var stateString: String
    @Persisted var createdAt: Double
    
    var state: OrderState? {
        return OrderState(rawValue: self.stateString)
    }
    
    convenience init(id: Int, name: String, shopId: Int, state: OrderState) {
        self.init()
        self.id = Int.random(in: 1...999999999)
        self.name = name
        self.shopId = shopId
        self.createdAt = Date().timeIntervalSince1970
        self.stateString = state.rawValue
    }
}

//class Shop: Object {
////    @Persisted var id: Int = 0
//    @Persisted var name: String = ""
//    @Persisted var city: String = ""
//    @Persisted var latitude: Double = 59.9355354
//    @Persisted var longitude: Double = 30.3260765
//    
//    public var coordinate: CLLocationCoordinate2D {
//        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
//    
//    convenience init(name: String, longitude: Double, latitude: Double, city: String) {
//        self.init()
//        self.longitude = longitude
//        self.latitude = latitude
//        self.name = name
//        self.city = city
//    }
//}
