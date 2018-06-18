//
//  AttachmentsCollectionViewDelegate.swift
//  June
//
//  Created by Ostap Holub on 10/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class AttachmentsCollectionViewDelegate: NSObject {
    
    // MARK: - Variables & Constants
    
    private weak var dataRespository: AttachmentsDataRepository?
    private var inset: CGFloat = 16
    
    private let rightInset: CGFloat = 0.088 * UIScreen.main.bounds.width
    
    var onOpenAttachment: ((Attachment) -> Void)?
    
    // MARK: - Initialization
    
    init(storage: AttachmentsDataRepository?) {
        dataRespository = storage
    }
}

    // MARK: - UICollectionViewDelegate

extension AttachmentsCollectionViewDelegate: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let attachment = dataRespository?.attachment(at: indexPath.item) {
            onOpenAttachment?(attachment)
        }
    }
}

    // MARK: - UICollectionViewDelegateFlowLayout

extension AttachmentsCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let attachment = dataRespository?.attachment(at: indexPath.item) {
            let attachmentComponents = attachment.filename.components(separatedBy: ".")
            if let attachmentFormat = attachmentComponents.last {
                let formatWidth = attachmentFormat.capitalized.width(usingFont: AttachmentsHelper.formatFont) + AttachmentsHelper.formatLabelOffset
                
                var attachmentNameWidth = attachment.filename.width(usingFont: AttachmentsHelper.labelFont)
                let maxWidth = AttachmentsHelper.maxNameLabelWidth
                if attachmentNameWidth > maxWidth {
                    attachmentNameWidth = maxWidth
                }
                
                let width = 4 * AttachmentsHelper.leftInset + formatWidth + attachmentNameWidth
                
                return CGSize(width: width, height: AttachmentsHelper.attachmentHeight)
            }
        }
        return .zero
    }
}

