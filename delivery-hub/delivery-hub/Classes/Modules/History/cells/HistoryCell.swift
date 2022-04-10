//
//  HistoryCell.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import UIKit

class HistoryCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.layer.cornerRadius = 10
            self.containerView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var statusLabel: UILabel! {
        didSet {
            self.statusLabel.layer.cornerRadius = 4
            self.statusLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(order: Order) {
        self.titleLabel.text = "Заказ #\(order.id)"
        self.statusLabel.backgroundColor = order.state?.color
        self.statusLabel.text = "  \(order.state?.title ?? "")  "
        self.dateLabel.text = Date.init(timeIntervalSince1970: order.createdAt).formate()
        self.orderDescriptionLabel.text = order.name
    }

}
