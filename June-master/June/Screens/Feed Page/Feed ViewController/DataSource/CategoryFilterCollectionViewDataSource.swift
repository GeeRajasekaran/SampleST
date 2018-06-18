//
//  CategoryFilterCollectionViewDataSource.swift
//  June
//
//  Created by Ostap Holub on 8/16/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class CategoryFilterCollectionViewDataSource: NSObject {
    
    // MARK: - Variables
    
    fileprivate let countOfSections: Int = 1
    private weak var dataRepository: FeedDataRepository?
    
    init(_ storage: FeedDataRepository?) {
        dataRepository = storage
    }
}

    // MARK: - UICollectionViewDataSource

extension CategoryFilterCollectionViewDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return countOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = dataRepository?.categoriesCount {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryFilterCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryFilterCollectionViewCell
        
        if let category = dataRepository?.category(at: indexPath.item) {
            cell.setupUI()
            cell.category = category
        }
        return cell
    }
}
