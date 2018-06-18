//
//  ToDetailsView.swift
//  June
//
//  Created by Ostap Holub on 9/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout

class ToDetailsView: UIView, UITextFieldDelegate {
    
    // MARK: - Variables & Constants
    
    private enum State {
        case expanded
        case collapsed
    }
    
    private let screenWidth = UIScreen.main.bounds.width
    var collectionView: UICollectionView?
    var onExpandAction: ((CGFloat) -> Void)?
    var onCollapseAction: (() -> Void)?
    
    weak var dataSource: ComposeEmailReceiversDataSource?
    weak var delegate: ComposeEmailReceiversDelegate?
    
    private var state: State = .collapsed
    
    // MARK: - Setup subviews
    
    func setupSubviews() {
        backgroundColor = .white
        addCollectionView()
        addComposeShadowView()
    }
    
    // MARK: - Insertion logic
    
    func insertReceiver(at indexPath: IndexPath) {
        collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: [indexPath])
        }, completion: { _ in
            self.scrollToEnd()
            if (self.collectionView?.contentSize.height)! > self.frame.height && self.state == .collapsed {
                self.state = .expanded
                self.collectionView?.frame.size.height = (self.collectionView?.contentSize.height)!
                self.frame.size.height = (self.collectionView?.contentSize.height)!
                self.scrollToEnd()
                self.onExpandAction?(self.frame.size.height)
            }
        })
    }
    
    func removeReceiver(at indexPath: IndexPath) {
        collectionView?.performBatchUpdates({
            self.collectionView?.deleteItems(at: [indexPath])
        }, completion: { _ in
            if (self.collectionView?.contentSize.height)! < self.frame.height && self.state == .expanded {
                self.state = .collapsed
                self.collectionView?.frame.size.height = 0.134 * self.screenWidth
                self.frame.size.height = 0.134 * self.screenWidth
                self.scrollToEnd()
                self.onCollapseAction?()
            }
        })
    }
    
    func updatePlaceholder(for index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let textFieldFont = UIFont.latoStyleAndSize(style: .bold, size: .medium)
        if let cell = collectionView?.cellForItem(at: indexPath) as? InputCollectionViewCell {
            cell.textField?.font = textFieldFont
            cell.textField?.attributedPlaceholder = NSAttributedString(string: "To", attributes: [.foregroundColor: UIColor.composeTitleGray.withAlphaComponent(0.65)])
            cell.textField?.textColor = UIColor.composeToFieldTextColor
            cell.textField?.autocapitalizationType = .sentences
            cell.textField?.autocorrectionType = .no
        }
    }
    
    private func scrollToEnd() {
        let numberOfItems = (collectionView?.numberOfItems(inSection: 0))! - 1
        if numberOfItems >= 0 {
            let indexPath = IndexPath(item: numberOfItems, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .right, animated: true)
        }
    }
    
    // MARK: - Collection view creation logic
    
    private func addCollectionView() {
//        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0.048 * screenWidth, bottom: 10, right: 0.04 * screenWidth)
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = .white
        collectionView?.register(InputCollectionViewCell.self, forCellWithReuseIdentifier: InputCollectionViewCell.reuseIdentifier)
        collectionView?.register(ComposeReceiverCollectionViewCell.self, forCellWithReuseIdentifier: ComposeReceiverCollectionViewCell.reuseIdentifier)
        collectionView?.dataSource = dataSource
        collectionView?.delegate = delegate
        
        if collectionView != nil {
            addSubview(collectionView!)
        }
    }
}
