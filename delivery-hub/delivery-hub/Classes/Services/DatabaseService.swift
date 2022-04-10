//
//  DatabaseService.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import UIKit
import RealmSwift

class DatabaseService: NSObject {

    static let shared = DatabaseService()
    var realm: Realm
    
    override init() {
        realm = try! Realm()
    }
    
    func getOrders() -> [Order] {
        return Array(realm.objects(Order.self)).sorted(by: { $0.createdAt > $1.createdAt })
    }
    
    func add(order: Order) {
        try! realm.write {
            realm.add(order)
        }
    }
    
    func update(order: Order, state: OrderState) {
        try! realm.write {
            order.stateString = state.rawValue
        }
    }
    
}
