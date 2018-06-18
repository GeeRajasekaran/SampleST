//
//  ResponderRecipientDelegate.swift
//  June
//
//  Created by Ostap Holub on 2/20/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderRecipientsDelegate: NSObject, IResponderRecipientsDelegate {
    
    unowned var dataRepository: IResponderRecipientsDataRepository
    private var inset: CGFloat = 16
    
    required init(storage: IResponderRecipientsDataRepository) {
        dataRepository = storage
    }
}

extension ResponderRecipientsDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let recipient = dataRepository.recipient(at: indexPath.item) else { return .zero }
        if recipient.destination == .display  {
            return displaySize(for: recipient, for: collectionView)
        } else if recipient.destination == .input {
            return inputSize(for: recipient, for: collectionView)
        }
        return .zero
    }
    
    private func displaySize(for recipient: EmailReceiver, for collectionView: UICollectionView) -> CGSize {
        var title = ""
        if recipient.name != "" {
            title = recipient.name ?? ""
        } else {
            title = recipient.email ?? ""
        }
        
        var titleWidth: CGFloat = 0
        if let font = UIFont(name: LocalizedFontNameKey.ResponderHelper.ReceiverTitleFont, size: 11) {
            titleWidth = title.width(usingFont: font) + 5
        }
        let totalWidth = inset + titleWidth + 2 * inset
        return CGSize(width: totalWidth, height: collectionView.frame.height - UIView.midMargin)
    }
    
    private func inputSize(for receiver: EmailReceiver, for collectionView: UICollectionView) -> CGSize {
        let count = dataRepository.count()
        if count > 1 {
            return CGSize(width: 0.4 * UIScreen.main.bounds.width, height: collectionView.frame.height)
        }
        return CGSize(width: 0.8 * UIScreen.main.bounds.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: UIView.narrowMidMargin, bottom: 0, right: UIView.narrowMidMargin)
    }
}
