//
//  AccessoryViewHeader.swift
//  June
//
//  Created by Ostap Holub on 9/14/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import SnapKit

class AccessoryViewHeader: UIView {
    
    // MARK: - Button state
    
    private enum State: String {
        case expanded
        case regular
    }
    
    // MARK: - Views
    
    private var expandButton: UIButton?
    private var receiversCollectionView: UICollectionView?
    private var topShadow: UIView?
    private var bottomShadow: UIView?
    private var recipientScroll: RecipientsScrollView?
    
    var onExpand: ((ResponderState) -> Void)?
    
    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private var state: State = .regular
    
    private weak var metadata: ResponderMetadata?
    private var isSubscribed: Bool = false
    
    private lazy var recipientsController: IRecipientsController = { [weak self] in
        let controller = ResponderRecipientsController(metadata: self?.metadata, onRemove: self?.onRemoveReceiver)
        return controller
    }()
    
    // MARK: - Public part
    
    func setupSubviews(for configuration: ResponderConfig) {
        backgroundColor = .white
        addExpandButton()
        addCollectionView()
    }
    
    func setupSubviews(for metadata: ResponderMetadata) {
        self.metadata = metadata
        backgroundColor = .white
        addShadows(for: metadata.state)
        if metadata.state == .regular {
            addExpandButton()
            addScrollView()
            recipientScroll?.addPlaceholderIfNeeded()
        }
    }
    
    func updateLayout(for metadata: ResponderMetadata) {
        topShadow?.removeFromSuperview()
        topShadow = nil
        bottomShadow?.removeFromSuperview()
        bottomShadow = nil
        setupSubviews(for: metadata)
    }
    
    // MARK: - Recipients collection actions
    
    func addRecipient(_ recipient: EmailReceiver) {
        recipientsController.dataRepository.append(recipient)
        metadata?.append(recipient)
        recipientScroll?.addRecipient(recipient)
        triggerTextInputClear()
        recipientScroll?.scrollToLastItem()
    }
    
    func removeLastRecipientIfNeeded() {
        guard recipientsController.dataRepository.count() > 1 else { return }
        let lastIndex = recipientsController.dataRepository.recipients.count - 2
        if let recipient = recipientsController.dataRepository.recipient(at: lastIndex) {
            onRemoveReceiver(recipient)
        }
    }
    
    lazy var onRemoveReceiver: (EmailReceiver) -> Void = { [weak self] recipient in
        self?.recipientScroll?.removeRecipient(recipient)
        guard let index = self?.recipientsController.dataRepository.index(of: recipient) else { return }
        self?.recipientsController.dataRepository.remove(at: index)
        if let nestedIndex = self?.metadata?.recipients.index(of: recipient) {
            self?.metadata?.recipients.remove(at: nestedIndex)
        }
        self?.reloadInputRecipientIfNeeded()
        NotificationCenter.default.post(name: .sendButtonCheck, object: nil)
    }
    
    private func reloadInputRecipientIfNeeded() {
        if recipientsController.dataRepository.count() == 1 {
            recipientScroll?.addPlaceholder()
        }
    }
    
    private func triggerTextInputClear() {
        NotificationCenter.default.post(name: .onClearTextInput, object: nil)
    }
    
    func setFistResponderForHeader() {
        let lastIndexPath = IndexPath(row: 0, section: 0)
        let cell = receiversCollectionView?.cellForItem(at: lastIndexPath) as? InputCollectionViewCell
        cell?.textField?.becomeFirstResponder()
    }
    
    func removeFirstResponder() {
        let lastIndexPath = IndexPath(row: 0, section: 0)
        let cell = receiversCollectionView?.cellForItem(at: lastIndexPath) as? InputCollectionViewCell
        cell?.textField?.resignFirstResponder()
    }
    
    // MARK: - Shadows
    
    private func addShadows(for state: ResponderState) {
        addTopShadowView(to: self)
        if state == .regular {
            addBottomShadowView(to: self)
        }
    }
    
    private func addBottomShadowView(to view: UIView) {
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.bottomSeparatorColor
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(shadowView)
        shadowView.snp.makeConstraints { [weak self] make in
            guard let sSelf = self else { return }
            make.leading.equalTo(sSelf).offset(ResponderLayoutConstants.Header.separatorInset)
            make.trailing.equalTo(sSelf).offset(-ResponderLayoutConstants.Header.separatorInset)
            make.bottom.equalTo(sSelf)
            make.height.equalTo(1)
        }
        bottomShadow = view
    }
    
    private func addTopShadowView(to view: UIView) {
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.topShadowColor
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(shadowView)
        shadowView.snp.makeConstraints { [weak self] make in
            guard let sSelf = self else { return }
            make.leading.equalTo(sSelf)
            make.trailing.equalTo(sSelf)
            make.top.equalTo(sSelf)
            make.height.equalTo(1)
        }
        topShadow = view
    }
    
    // MARK: - Receivers collection view
    
    private func addScrollView() {
        guard recipientScroll == nil else { return }
        recipientScroll = RecipientsScrollView(frame: CGRect(x: 0, y: 1, width: UIScreen.main.bounds.width - ResponderLayoutConstants.Header.expandButtonWidth, height: ResponderLayoutConstants.Header.height - 2))
        recipientScroll?.backgroundColor = .clear
        recipientScroll?.onRemoveAction = onRemoveReceiver
        
        recipientScroll?.dataRepository = recipientsController.dataRepository as? ResponderRecipientsDataRepository
        recipientScroll?.populateRecipients()
        
        if recipientScroll != nil {
            addSubview(recipientScroll!)
        }
    }
    
    private func addCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        receiversCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        receiversCollectionView?.backgroundColor = .clear
        receiversCollectionView?.showsHorizontalScrollIndicator = false
        receiversCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        receiversCollectionView?.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: PersonCollectionViewCell.reuseIdentifier)
        receiversCollectionView?.register(InputCollectionViewCell.self, forCellWithReuseIdentifier: InputCollectionViewCell.reuseIdentifier)

        receiversCollectionView?.dataSource = recipientsController.dataSource
        receiversCollectionView?.delegate = recipientsController.delegate
        if receiversCollectionView != nil {
            addSubview(receiversCollectionView!)
            receiversCollectionView?.snp.makeConstraints { [weak self] make in
                guard let sSelf = self else { return }
                make.leading.equalTo(sSelf)
                make.top.equalTo(sSelf)
                make.bottom.equalTo(sSelf)
                make.trailing.equalTo(sSelf).offset(-ResponderLayoutConstants.Header.expandButtonWidth)
            }
        }
    }
    
    private func setZeroContentOffset() {
        receiversCollectionView?.setContentOffset(.zero, animated: true)
    }
    
    // MARK: - Expand button
    
    private func addExpandButton() {
        let image = UIImage(named: LocalizedImageNameKey.ResponderHelper.Expand)
        expandButton = UIButton()
        expandButton?.translatesAutoresizingMaskIntoConstraints = false
        expandButton?.setImage(image, for: .normal)
        expandButton?.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        
        if expandButton != nil {
            addSubview(expandButton!)
            expandButton?.snp.makeConstraints { [weak self] make in
                guard let sSelf = self else { return }
                make.trailing.equalTo(sSelf)
                make.top.equalTo(sSelf)
                make.bottom.equalTo(sSelf)
                make.width.equalTo(ResponderLayoutConstants.Header.expandButtonWidth)
            }
        }
    }
    
    @objc private func handleButtonTap() {
        var imageName = ""
        if state == .expanded {
            state = .regular
            imageName = LocalizedImageNameKey.ResponderHelper.Expand
        } else if state == .regular {
            state = .expanded
            imageName = LocalizedImageNameKey.ResponderHelper.Collapse
        }
        let image = UIImage(named: imageName)
        expandButton?.setImage(image, for: .normal)
        let userInfo: [String: String] = ["state": state.rawValue]
        if let responderState = ResponderState(rawValue: state.rawValue) {
            onExpand?(responderState)
        }
        NotificationCenter.default.post(name: .onExpandClicked, object: nil, userInfo: userInfo)
    }
}
