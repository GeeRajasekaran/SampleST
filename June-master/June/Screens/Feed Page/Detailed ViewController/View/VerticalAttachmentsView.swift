//
//  VerticalAttachmentsView.swift
//  June
//
//  Created by Oksana Hanailiuk on 11/14/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class VerticalAttachmentsView: UIView {

    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private var collectionView: UICollectionView?
    private weak var currentMessage: Messages?
    var onOpenAttachment: ((Attachment) -> Void)?
    
    private lazy var dataRepository: AttachmentsDataRepository = {
        let storage = AttachmentsDataRepository(message: self.currentMessage)
        return storage
    }()
    
    private lazy var dataSource: VerticalAttachmentsDataSource = {
        let source = VerticalAttachmentsDataSource(storage: self.dataRepository)
        return source
    }()
    
    private lazy var delegate: VerticalAttachmentsDelegate = {
        let delegate = VerticalAttachmentsDelegate(storage: self.dataRepository)
        delegate.onOpenAttachment = self.onOpenAttachment
        return delegate
    }()
    
    // MARK: - Public view setup
    
    func setupSubviews(for message: Messages? = nil) {
        currentMessage = message
        addCollectionView()
    }
    
    // MARK: - Append new attachment
    
    func append(_ attachment: Attachment) {
        dataRepository.append(attachment)
        collectionView?.reloadData()
    }
    
    //MARK: get attachments count
    func getAttachmentsCount() -> Int? {
        return dataRepository.count
    }
    
    //MARK: get attachments
    func getAttachments() -> [Attachment] {
        return dataRepository.getAttachments()
    }
    
    // MARK: - Collection view setup
    
    private func addCollectionView() {
        if collectionView != nil { return }
        //        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .center)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.016 * screenWidth, left: 0, bottom: 0.016 * screenWidth, right: 0)
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(VerticalAttachmentCollectionViewCell.self, forCellWithReuseIdentifier: VerticalAttachmentCollectionViewCell.reuseIdentifier())
        collectionView?.backgroundColor = .white
        collectionView?.dataSource = dataSource
        collectionView?.delegate = delegate
        
        if collectionView != nil {
            addSubview(collectionView!)
        }
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    

}
