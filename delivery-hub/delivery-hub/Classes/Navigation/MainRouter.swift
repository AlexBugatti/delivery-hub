//
//  MainRouter.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import Foundation
import UIKit

class MainRouter: NSObject {
    var navigationController: UINavigationController
    
    override init() {
        let vc = SplashController(nibName: nil, bundle: nil)
        self.navigationController = UINavigationController(rootViewController: vc)
        
        self.navigationController.setNavigationBarHidden(true, animated: false)
        super.init()
        vc.didLoad = {
            self.mainFlow()
        }
    }
    
    func start() {
        
    }
    
    func mainFlow() {
        let main = MainTabBarController()
        self.navigationController.setViewControllers([main], animated: true)
    }
}
