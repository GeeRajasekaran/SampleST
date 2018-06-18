//
//  EmailReceiverDelegate.swift
//  June
//
//  Created by Ostap Holub on 9/18/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class EmailReceiverDelegate: NSObject {
    
    // MARK: - Variables
    
    fileprivate weak var dataStorage: EmailReceiversDataRepository?
    fileprivate var inset: CGFloat = 16
    
    // MARK: - Initialization
    
    init(storage: EmailReceiversDataRepository?) {
        dataStorage = storage
        super.init()
    }
    
}

extension EmailReceiverDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let receiver = dataStorage?.receivers[indexPath.item] else { return .zero }
        if receiver.destination == .display  {
            return displaySize(for: receiver, for: collectionView)
        } else if receiver.destination == .input {
            return inputSize(for: receiver, for: collectionView)
        }
        return .zero
    }
    
    private func displaySize(for receiver: EmailReceiver, for collectionView: UICollectionView) -> CGSize {
        var title = ""
        if receiver.name != "" {
            title = receiver.name ?? ""
        } else {
            title = receiver.email ?? ""
        }
        
        var titleWidth: CGFloat = 0
        if let font = UIFont(name: LocalizedFontNameKey.ResponderHelper.ReceiverTitleFont, size: 11) {
            titleWidth = title.width(usingFont: font) + 5
        }
        let totalWidth = inset + titleWidth + 2 * inset
        return CGSize(width: totalWidth, height: collectionView.frame.height - UIView.midInterMargin)
    }
    
    private func inputSize(for receiver: EmailReceiver, for collectionView: UICollectionView) -> CGSize {
        guard let count = dataStorage?.receivers.count else { return .zero }
        if count > 1 {
            return CGSize(width: 0.4*UIScreen.main.bounds.width, height: collectionView.frame.height)
        }
        return CGSize(width: 0.8*UIScreen.main.bounds.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: UIView.midMargin, bottom: 0, right: UIView.midMargin)
    }
}
