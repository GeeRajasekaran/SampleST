//
//  ContactsDataSource.swift
//  June
//
//  Created by Ostap Holub on 9/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class ComposeEmailReceiversDataSource: NSObject {
    
    // MARK: - Variables
    fileprivate weak var dataStorage: EmailReceiversDataRepository?
    var onRemoveReceiver: ((Int) -> Void)?
    var onReturnAction: ((String) -> Void)?
    
    // MARK: - Initialization
    
    init(storage: EmailReceiversDataRepository?) {
        dataStorage = storage
        super.init()
    }
    
    // MARK: - Remove action
    
    lazy var onCloseButtonAction: (EmailReceiver) -> Void = { [weak self] receiver in
        if let index = self?.dataStorage?.receivers.index(of: receiver) {
            self?.onRemoveReceiver?(index)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ComposeEmailReceiversDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = dataStorage?.receivers.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let receiver = dataStorage?.receivers[indexPath.item] else { return UICollectionViewCell() }
        
        if receiver.destination == .display {
            return displayCell(for: collectionView, at: indexPath)
        } else {
            return inputCell(for: collectionView, at: indexPath)
        }
    }
    
    private func displayCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComposeReceiverCollectionViewCell.reuseIdentifier, for: indexPath) as! ComposeReceiverCollectionViewCell
        cell.setupViews()
        if let receiver = dataStorage?.receivers[indexPath.item] {
            cell.onCloseAction = onCloseButtonAction
            cell.loadReceiver(receiver)
        }
        return cell
    }
    
    private func inputCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InputCollectionViewCell.reuseIdentifier, for: indexPath) as! InputCollectionViewCell
        cell.setupViews()
        if indexPath.item == 0 {
            cell.textField?.font = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
            cell.textField?.attributedPlaceholder = NSAttributedString(string: "To", attributes: [.foregroundColor: UIColor.participantsLabelGray])
            cell.textField?.textColor = UIColor.composeToFieldTextColor
            cell.textField?.autocapitalizationType = .sentences
            cell.textField?.autocorrectionType = .no
            
            cell.onReturnAction = onReturnAction
        } else {
            cell.removePlaceholder()
        }
        return cell
    }
}

