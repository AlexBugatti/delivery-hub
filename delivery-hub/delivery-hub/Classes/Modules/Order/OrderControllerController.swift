//
//  OrderControllerController.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import UIKit

class OrderControllerController: UIViewController {

    static let traslationOffset: CGFloat = 50
    var initialCenter: CGPoint = .zero
    var translationX: CGFloat = 0
    
    var currentOffer: Offer = DeliveryService.shared.generateOffer()
    var nextOffer: Offer = DeliveryService.shared.generateOffer()
    var activeOrder: Order?
    
    @IBOutlet weak var containerActiveOrderView: UIView!
    @IBOutlet weak var containerOrderView: UIView!
    
    @IBOutlet weak var currentOrderView: OrderView!
    @IBOutlet weak var nextOrderView: OrderView!
    
    
    @IBOutlet weak var completeButton: UIButton! {
        didSet {
            self.completeButton.layer.cornerRadius = 10
            self.completeButton.layer.masksToBounds = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configure()
        configureOrders()
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onDidPanGesture(recognizer:)))
        panRecognizer.delegate = self
        currentOrderView.addGestureRecognizer(panRecognizer)
        // Do any additional setup after loading the view.
    }
    
    private func configure() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Активные заказы"
        view.backgroundColor = Colors.background
    }
    
    private func setup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.initialCenter = self.currentOrderView.center
        }
    }
    
    private func configureOrders() {
        if let activeOrder = DatabaseService.shared.getOrders().first(where: { $0.state == .active }) {
            self.activeOrder = activeOrder
            self.showActiveOrderState()
        } else {
            self.showOrderState()
        }
        
        nextOrderView.configure(offer: nextOffer)
        currentOrderView.configure(offer: currentOffer)
        currentOrderView.didAccept = {
            DispatchQueue.main.async {
                self.nextOrderView.isHidden = true
                let point = CGPoint(x: self.initialCenter.x + 400, y: self.initialCenter.y)
                UIView.animate(withDuration: 0.2) {
                    self.currentOrderView.center = point
                } completion: { complete in
                    self.currentOrderView.alpha = 1
                    self.currentOrderView.center = self.initialCenter
                    self.acceptOrder()
                }
            }
        }
        currentOrderView.didCancel = {
            DispatchQueue.main.async {
                let point = CGPoint(x: self.initialCenter.x - 400, y: self.initialCenter.y)
                UIView.animate(withDuration: 0.2) {
                    self.currentOrderView.center = point
                } completion: { complete in
                    self.currentOrderView.alpha = 1
                    self.currentOrderView.center = self.initialCenter
                    self.cancelOrder()
                }
            }
        }
    }
    
    @IBAction func didCompleteOrder(_ sender: Any) {
        if activeOrder != nil {
            DatabaseService.shared.update(order: self.activeOrder!, state: .completed)
            self.activeOrder = nil
            self.next()
            self.showOrderState()
        }
    }
    
    func acceptOrder() {
        let order = Order(id: Int.random(in: 10...9999999), name: "Заказ из \(self.currentOffer.shop.name) по адресу г. \(self.currentOffer.shop.city), \(self.currentOffer.shop.street) на сумму \(self.currentOffer.cost)", shopId: self.currentOffer.shop.id, state: .active)
        DatabaseService.shared.add(order: order)
        if let activeOrder = DatabaseService.shared.getOrders().first(where: { $0.state == .active }) {
            self.activeOrder = activeOrder
            self.showActiveOrderState()
        }
    }
    
    func cancelOrder() {
        let order = Order(id: Int.random(in: 10...9999999), name: "Заказ из \(self.currentOffer.shop.name) по адресу г. \(self.currentOffer.shop.city), \(self.currentOffer.shop.street) на сумму \(self.currentOffer.cost)", shopId: self.currentOffer.shop.id, state: .cancelled)
        DatabaseService.shared.add(order: order)
        next()
    }
    
    func next() {
        self.currentOffer = self.nextOffer
        self.nextOffer = DeliveryService.shared.generateOffer()
        self.currentOrderView.configure(offer: currentOffer)
        self.nextOrderView.configure(offer: nextOffer)
    }
    
    func showActiveOrderState() {
        self.nextOrderView.isHidden = true
        self.containerActiveOrderView.isHidden = false
        self.containerOrderView.isHidden = true
    }

    func showOrderState() {
        self.containerActiveOrderView.isHidden = true
        self.containerOrderView.isHidden = false
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

extension OrderControllerController: UIGestureRecognizerDelegate {

    @objc func onDidPanGesture(recognizer: UIPanGestureRecognizer) {
        print(recognizer.state)
        switch recognizer.state {
            case .began:
                print("began")
            case .changed:
                print("changed")
                let translation = recognizer.translation(in: view)
                
                let translationPoint = CGPoint(x: initialCenter.x + translation.x,
                                               y: initialCenter.y + translation.y)
                currentOrderView.center = translationPoint
                currentOrderView.set(translation: translation.x)
                translationX = translation.x
            case .cancelled:
                print("cancelled")
            case .ended:
                print("ended")
                var point: CGPoint = initialCenter
                var vote: Bool = false
                if translationX > OrderControllerController.traslationOffset {
                    vote = true
                    point = CGPoint(x: initialCenter.x + 400, y: initialCenter.y)
                } else if translationX < -OrderControllerController.traslationOffset {
                    vote = false
                    point = CGPoint.init(x: initialCenter.x - 400, y: initialCenter.y)
                } else {
                    point = initialCenter
                }
            
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseInOut]) {
                        if point != self.initialCenter {
                            self.currentOrderView.alpha = 0
                            self.currentOrderView.set(translation: 0)
                        }
                        self.currentOrderView.center = point
                    } completion: { completion in
                        print("stop animate")
                        if point != self.initialCenter {
                            if vote == true {
                                self.currentOrderView.alpha = 1
                                self.currentOrderView.center = self.initialCenter
                                self.acceptOrder()
                            } else {
                                self.currentOrderView.alpha = 1
                                self.currentOrderView.center = self.initialCenter

                                self.cancelOrder()
                            }
                        }
                    }

                }
                
            default:
                break
            }
    }
    
}
