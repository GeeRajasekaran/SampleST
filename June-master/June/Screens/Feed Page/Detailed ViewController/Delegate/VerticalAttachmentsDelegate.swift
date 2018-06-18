//
//  VerticalAttachmentsDelegate.swift
//  June
//
//  Created by Oksana Hanailiuk on 11/14/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class VerticalAttachmentsDelegate: NSObject {
    
    private weak var dataRespository: AttachmentsDataRepository?
    
    private let imageRightInset: CGFloat = UIView.narrowMargin
    private let cellWidth: CGFloat = 0.746 * UIScreen.main.bounds.width
    private let cellHeight: CGFloat = 0.189 * UIScreen.main.bounds.width
    
     var onOpenAttachment: ((Attachment) -> Void)?
    // MARK: - Initialization
    
    init(storage: AttachmentsDataRepository?) {
        dataRespository = storage
    }
}

// MARK: - UICollectionViewDelegate

extension VerticalAttachmentsDelegate: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let attachment = dataRespository?.attachment(at: indexPath.item) {
            onOpenAttachment?(attachment)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension VerticalAttachmentsDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
