//
//  AttachmetsView.swift
//  June
//
//  Created by Ostap Holub on 10/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout

class AttachmentsView: UIView {
    
    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private var collectionView: UICollectionView?
    private var bottomLineView: UIView?
    private weak var currentMessage: Messages?
    
    var onOpenAttachment: ((Attachment) -> Void)?
    var onRemovedAttachment: (() -> Void)?
    var shouldShowRemoveButton: Bool = false
    
    var onRemove: ((Attachment) -> Void)?
    // MARK: - Data storing
    
    private lazy var dataRepository: AttachmentsDataRepository = {
        let storage = AttachmentsDataRepository(message: self.currentMessage)
        return storage
    }()
    
    private lazy var dataSource: AttachmentsDataSource = {
        let source = AttachmentsDataSource(storage: self.dataRepository)
        source.shouldShowRemoveButton = self.shouldShowRemoveButton
        source.onRemoveAttachment = self.onRemoveAttachmentAction
        source.onOpenAttachment = self.onOpenAttachment
        return source
    }()
    
    private lazy var delegate: AttachmentsCollectionViewDelegate = {
        let delegate = AttachmentsCollectionViewDelegate(storage: self.dataRepository)
        delegate.onOpenAttachment = self.onOpenAttachment
        return delegate
    }()
    
    // MARK: - Public view setup
    
    func setupSubviews(for metadata: ResponderMetadata) {
        currentMessage = metadata.config.message
        shouldShowRemoveButton = true
        dataRepository.setAttachments(metadata.attachments)
        addCollectionView()
    }
    
    func setupSubviews(for message: Messages? = nil, shouldDrawShadow: Bool = false) {
        currentMessage = message
        addCollectionView()
        if shouldDrawShadow {
            addComposeShadowView()
        }
    }
    
    // MARK: - Append new attachment
    
    func add(_ attachments: [Attachment]) {
        dataRepository.append(attachments)
        collectionView?.reloadData()
        addBottomLineView()
    }
    
    func append(_ attachment: Attachment) {
        dataRepository.append(attachment)
        collectionView?.reloadData()
        addBottomLineView()
    }
    
    func clear() {
        dataRepository.clear()
        collectionView?.reloadData()
        bottomLineView?.removeFromSuperview()
        bottomLineView = nil
    }
    
    //MARK: - Remove attachment
    lazy var onRemoveAttachmentAction: (Int) -> Void = { [weak self] index in
        self?.dataRepository.removeAttachemntFromeCoreData(at: index)
        if let attachment = self?.dataRepository.attachment(at: index) {
            self?.onRemove?(attachment)
        }
        self?.dataRepository.remove(at: index)
        self?.collectionView?.reloadData()
        self?.onRemovedAttachment?()
        if self?.dataRepository.count == 0 {
            self?.bottomLineView?.removeFromSuperview()
            self?.bottomLineView = nil
        }
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0.04 * screenWidth, bottom: 0, right: 0.04 * screenWidth)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(AttachmentCollectionViewCell.self, forCellWithReuseIdentifier: AttachmentCollectionViewCell.reuseIdentifier())
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
    
    //Bottom line view
    private func addBottomLineView() {
        if bottomLineView != nil { return }
        bottomLineView = UIView()
        bottomLineView?.backgroundColor = UIColor.newsCardSeparatorGray
        bottomLineView?.translatesAutoresizingMaskIntoConstraints = false
        
        if bottomLineView != nil {
            self.addSubview(bottomLineView!)
        }
        bottomLineView?.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomLineView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        bottomLineView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        bottomLineView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}
