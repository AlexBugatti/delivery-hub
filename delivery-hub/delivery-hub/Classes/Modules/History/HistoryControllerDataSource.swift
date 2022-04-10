//
//  HistoryControllerDataSource.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import Foundation
import UIKit

class HistoryControllerDataSource: NSObject {
    
    private var items: [Order] = []
    private var collectionView: UICollectionView
    
    init(collectionView: UICollectionView, items: [Order]) {
        self.collectionView = collectionView
        self.items = items
        super.init()
        configure()
    }
    
    func update(items: [Order]) {
        self.items = items
        self.collectionView.reloadData()
    }
    
}

extension HistoryControllerDataSource: UICollectionViewDelegate {
    
    
    
}

extension HistoryControllerDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.history.rawValue, for: indexPath) as! HistoryCell
        cell.configure(order: item)
        return cell
    }
    
    
    
}

extension HistoryControllerDataSource {
    
    enum Cell: String {
        case history = "HistoryCell"
    }
    
    func configure() {
        self.collectionView.register(UINib(nibName: Cell.history.rawValue, bundle: nil), forCellWithReuseIdentifier: Cell.history.rawValue)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
}
