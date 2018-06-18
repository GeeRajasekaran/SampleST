//
//  CategoryFilterCollectionViewDelegate.swift
//  June
//
//  Created by Ostap Holub on 8/16/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class CategoryFilterCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    // MARK: - Variables
    
    private var onSelectCategory: ((FeedCategory) -> Void)?
    private weak var dataRepository: FeedDataRepository?
    
    init(_ storage: FeedDataRepository?, onSelect: ((FeedCategory) -> Void)?) {
        dataRepository = storage
        onSelectCategory = onSelect
    }
    
    // MARK: - Selection logic
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let category = dataRepository?.category(at: indexPath.item) {
            onSelectCategory?(category)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CategoryFilterCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        if let count = dataRepository?.categoriesCount {
            return CGSize(width: screenWidth / CGFloat(count), height: collectionView.frame.height)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
    }
}
