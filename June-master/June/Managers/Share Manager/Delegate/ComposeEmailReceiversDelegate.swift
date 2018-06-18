//
//  ComposeEmailReceiversDelegate.swift
//  June
//
//  Created by Ostap Holub on 10/4/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ComposeEmailReceiversDelegate: NSObject {
    
    // MARK: - Variables
    
    private var screenWidth = UIScreen.main.bounds.width
    private weak var dataStorage: EmailReceiversDataRepository?
    private var inset: CGFloat = 16
    private var cellHeight: CGFloat = 0.074 * UIScreen.main.bounds.width
    
    // MARK: - Initialization
    
    init(storage: EmailReceiversDataRepository?) {
        dataStorage = storage
        super.init()
    }
    
}

extension ComposeEmailReceiversDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is InputCollectionViewCell && indexPath.item == 0 {
            (cell as! InputCollectionViewCell).setFirstResponder()
        }
    }
}

extension ComposeEmailReceiversDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let receiver = dataStorage?.receivers[indexPath.item] else { return .zero }
        if receiver.destination == .display  {
            return displaySize(for: receiver, for: collectionView)
        } else if receiver.destination == .input {
            return inputSize(for: receiver, for: collectionView, at: indexPath)
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
        return CGSize(width: totalWidth, height: cellHeight)
    }
    
    private func inputSize(for receiver: EmailReceiver, for collectionView: UICollectionView, at indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: screenWidth - 20, height: cellHeight)
        }
        return CGSize(width: 100, height: cellHeight)
    }
}
