//
//  AppDelegate.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        configureDataBase()
        configureNavbar()
        
        let mainRouter = MainRouter()
        self.window?.rootViewController = mainRouter.navigationController
    
        
        return true
    }
    
    func configureNavbar() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)]
    }
    
    func configureDataBase() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { _, oldSchemaVersion in
                if oldSchemaVersion < 1 {}
            })
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
    }

}

