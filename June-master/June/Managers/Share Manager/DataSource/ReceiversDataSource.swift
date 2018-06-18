//
//  ReceiversDataSource.swift
//  June
//
//  Created by Ostap Holub on 10/3/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class ReceiversDataSource: NSObject {
    
    // MARK: - Variables and Constants
    
    private var receivers = [EmailReceiver]()
    private var onCloseButtonAction: (EmailReceiver) -> Void
    
    // MARK: - Initialization
    
    init(onCloseAction: @escaping (EmailReceiver) -> Void) {
        onCloseButtonAction = onCloseAction
        super.init()
        
        let inputReceiver = EmailReceiver(name: "", email: "", destination: .input)
        append(inputReceiver)
    }
    
    // MARK: - Accessing methods
    
    var count: Int {
        get { return receivers.count }
    }
    
    @discardableResult func append(_ receiver: EmailReceiver) -> Int? {
        receivers.append(receiver)
        return index(of: receiver)
    }
    
    func receiver(at index: Int) -> EmailReceiver? {
        if index >= 0 && index < receivers.count {
            return receivers[index]
        }
        return nil
    }
    
    func index(of receiver: EmailReceiver) -> Int? {
        return receivers.index(of: receiver)
    }
    
    func remove(_ receiver: EmailReceiver) {
        if let index = index(of: receiver) {
            receivers.remove(at: index)
        }
    }
}

    // MARK: - UICollectionViewDataSource

extension ReceiversDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receivers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let receiver = receiver(at: indexPath.item) else { return UICollectionViewCell() }
        
        if receiver.destination == .display {
            return displayCell(for: collectionView, at: indexPath)
        } else {
            return inputCell(for: collectionView, at: indexPath)
        }
    }
    
    private func displayCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCollectionViewCell.reuseIdentifier, for: indexPath) as! PersonCollectionViewCell
        cell.setupViews()
        if let receiver = receiver(at: indexPath.item) {
            cell.onCloseAction = onCloseButtonAction
            cell.loadReceiver(receiver)
        }
        return cell
    }
    
    private func inputCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InputCollectionViewCell.reuseIdentifier, for: indexPath) as! InputCollectionViewCell
        cell.setupViews()
        if indexPath.item == 0 {
            cell.addPlaceholder()
        } else {
            cell.removePlaceholder()
        }
        return cell
    }
}
