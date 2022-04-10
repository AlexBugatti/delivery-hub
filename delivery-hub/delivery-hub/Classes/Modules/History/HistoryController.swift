//
//  HistoryController.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import UIKit

class HistoryController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var historyDataSoure: HistoryControllerDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "История"
        view.backgroundColor = Colors.background
        configureDataSource()
        configureLayout()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDataSource()
    }
    
    func configureLayout() {
        let width = UIScreen.main.bounds.size.width - (2 * 20)
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.absolute(width),
            heightDimension: NSCollectionLayoutDimension.estimated(74)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
    }
    
    func configureDataSource() {
        let orders = DatabaseService.shared.getOrders()
        historyDataSoure = HistoryControllerDataSource(collectionView: collectionView, items: orders)
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
