//
//  AttachmentsDataSource.swift
//  June
//
//  Created by Ostap Holub on 10/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class AttachmentsDataSource: NSObject {
    
    // MARK: - Variables & Constants
    
    private weak var dataRepository: AttachmentsDataRepository?
    var onRemoveAttachment: ((Int) -> Void)?
    var onOpenAttachment: ((Attachment) -> Void)?
    var shouldShowRemoveButton: Bool = false
    // MARK: - Initialization
    
    init(storage: AttachmentsDataRepository?) {
        dataRepository = storage
    }
    
    // MARK: - Remove action
    
    lazy var onCloseButtonAction: (Attachment) -> Void = { [weak self] attachment in
        if let index = self?.dataRepository?.index(of: attachment) {
            self?.onRemoveAttachment?(index)
        }
    }
}

    // MARK: - UICollectionViewDataSource

extension AttachmentsDataSource: UICollectionViewDataSource {
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttachmentCollectionViewCell.reuseIdentifier(), for: indexPath) as! AttachmentCollectionViewCell
        if let attachment = dataRepository?.attachment(at: indexPath.item) {
            cell.onOpenAttachment = onOpenAttachment
            cell.onCloseAction = onCloseButtonAction
            cell.setupSubviews(for: attachment, showRemoveButton: shouldShowRemoveButton)
        }
        return cell
    }
}
