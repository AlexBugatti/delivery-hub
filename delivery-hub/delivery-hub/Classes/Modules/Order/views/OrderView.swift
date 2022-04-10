//
//  OrderView.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import UIKit

class OrderView: NibView {

    var didCancel: Closure?
    var didAccept: Closure?
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            self.cancelButton.layer.cornerRadius = 10
            self.cancelButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var acceptButton: UIButton! {
        didSet {
            self.acceptButton.layer.cornerRadius = 10
            self.acceptButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.layer.cornerRadius = 20
            self.containerView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView! {
        didSet {
            self.logoView.layer.cornerRadius = 10
            self.logoView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            self.backgroundView.layer.borderWidth = 6
            self.backgroundView.layer.cornerRadius = 20
            self.backgroundView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    
    @IBAction func onDidCancelTapped(_ sender: Any) {
        didCancel?()
    }
    
    @IBAction func onDidAcceptTapped(_ sender: Any) {
        didAccept?()
    }
    
    func configure(offer: Offer) {
        let name = "Заказ из \(offer.shop.name) по адресу г. \(offer.shop.city), \(offer.shop.street) на сумму \(offer.cost)₽"
        nameLabel.text = name
//        nameLabel.text = offer.shop.name
//        timeLabel.text = Date(timeIntervalSince1970: offer.timestamp).formate()
//        summaryLabel.text = "Сумма заказа \(offer.cost)₽"
    }
    
    func set(translation: CGFloat) {
        print(translation)
        var offset = abs(translation) - OrderControllerController.traslationOffset
        if offset < 0 {
            offset = 0
        }
        let alpha = abs(offset / 3) / 100
        let color = translation > 0 ? Colors.green : UIColor.red
        self.backgroundView.layer.borderColor = color.withAlphaComponent(alpha).cgColor
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
