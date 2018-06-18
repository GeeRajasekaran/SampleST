//
//  ResponderRecipientsDataSource.swift
//  June
//
//  Created by Ostap Holub on 2/20/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderRecipientsDataSource: NSObject, IResponderRecipientsDataSource {
    
    unowned var dataRepository: IResponderRecipientsDataRepository
    var onRemoveAction: ((EmailReceiver) -> Void)?
    
    required init(storage: IResponderRecipientsDataRepository, onRemove: ((EmailReceiver) -> Void)?) {
        dataRepository = storage
        onRemoveAction = onRemove
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataRepository.count()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let recipient = dataRepository.recipient(at: indexPath.item) else { return UICollectionViewCell() }
        
        if recipient.destination == .display {
            return displayCell(for: collectionView, at: indexPath)
        } else {
            return inputCell(for: collectionView, at: indexPath)
        }
    }
    
    private func displayCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCollectionViewCell.reuseIdentifier, for: indexPath) as! PersonCollectionViewCell
        cell.setupViews()
        if let recipient = dataRepository.recipient(at: indexPath.item) {
            cell.onCloseAction = onRemoveAction
            cell.loadReceiver(recipient)
        }
        return cell
    }
    
    private func inputCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InputCollectionViewCell.reuseIdentifier, for: indexPath) as! InputCollectionViewCell
        cell.setupViews()
//        cell.onReturnAction = onReturnAction
        if indexPath.item == 0 {
            cell.addPlaceholder()
        } else {
            cell.removePlaceholder()
        }
        return cell
    }
}
