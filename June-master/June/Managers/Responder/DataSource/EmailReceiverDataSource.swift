//
//  ContactsDataSource.swift
//  June
//
//  Created by Ostap Holub on 9/15/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class EmailReceiverDataSource: NSObject {
    
    // MARK: - Variables
    weak var dataStorage: EmailReceiversDataRepository?
    var goal: ResponderOld.ResponderGoal?
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

extension EmailReceiverDataSource: UICollectionViewDataSource {
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCollectionViewCell.reuseIdentifier, for: indexPath) as! PersonCollectionViewCell
        cell.setupViews()
        if let receiver = dataStorage?.receivers[indexPath.item] {
            cell.onCloseAction = onCloseButtonAction
            cell.loadReceiver(receiver)
        }
        return cell
    }
    
    private func inputCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InputCollectionViewCell.reuseIdentifier, for: indexPath) as! InputCollectionViewCell
        cell.fromShareInJune = goal == .forward ? true : false
        cell.setupViews()
        cell.onReturnAction = onReturnAction
        if indexPath.item == 0 {
            cell.addPlaceholder()
        } else {
            cell.removePlaceholder()
        }
        return cell
    }
}
