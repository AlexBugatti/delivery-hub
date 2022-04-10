//
//  MainTabBarController.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    private lazy var orderController: OrderControllerController = {
        var vc = OrderControllerController(nibName: nil, bundle: nil)
        let item = UITabBarItem(title: "Активные заказы", image: UIImage(named: "tab-order"), selectedImage: UIImage(named: "tab-order-selected"))
        
        vc.tabBarItem = item
        return vc
    }()
    private lazy var historyController: HistoryController = {
        var vc = HistoryController(nibName: nil, bundle: nil)
        let item = UITabBarItem(title: "История", image: UIImage(named: "tab-history"), selectedImage: UIImage(named: "tab-history"))
        vc.tabBarItem = item
        return vc
    }()
    private lazy var mapController: MapController = {
        var vc = MapController(nibName: nil, bundle: nil)
        let item = UITabBarItem(title: "Карта", image: UIImage(named: "tab-map"), selectedImage: UIImage(named: "tab-map"))
        vc.tabBarItem = item
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confugure()
        // Do any additional setup after loading the view.
    }
    
    private func confugure() {
        tabBar.unselectedItemTintColor = Colors.gray
        tabBar.tintColor = Colors.green
        setViewControllers([UINavigationController(rootViewController: orderController),
                            UINavigationController(rootViewController: historyController), mapController], animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
