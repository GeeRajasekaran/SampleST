//
//  VerticalAttachmentsDataSource.swift
//  June
//
//  Created by Oksana Hanailiuk on 11/14/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class VerticalAttachmentsDataSource: NSObject {

    // MARK: - Variables & Constants
    
     private weak var dataRepository: AttachmentsDataRepository?
    
    init(storage: AttachmentsDataRepository?) {
        dataRepository = storage
    }
}

extension VerticalAttachmentsDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = dataRepository?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalAttachmentCollectionViewCell.reuseIdentifier(), for: indexPath) as! VerticalAttachmentCollectionViewCell
        if let attachment = dataRepository?.attachment(at: indexPath.item) {
            cell.setupSubviews(for: attachment)
            
        }
        return cell
    }
}
