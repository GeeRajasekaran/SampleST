//
//  MailDetailsView.swift
//  June
//
//  Created by Ostap Holub on 9/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class MailDetailsView: UIView {
    
    // MARK: - Nested state enum
    
    private enum State {
        case expanded
        case collapsed
    }
    
    // MARK: - Variables & Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let viewHeight = 0.132 * UIScreen.main.bounds.width
    private let attachmentsViewHeight = 0.15 * UIScreen.main.bounds.width
    
    private var toDetailedView: ToDetailsView?
    private var subjectDetailedView: SubjectDetailsView?
    private var fromDetailedView: FromDetailView?
    private var attachmentsView: AttachmentsView?
    private var state: State = .collapsed
    
    weak var toFieldDataSource: ComposeEmailReceiversDataSource?
    weak var toFieldDelegate: ComposeEmailReceiversDelegate?
    
    var onExpandAction: ((Bool) -> Void)?
    var onToExpandAction: ((CGFloat) -> Void)?
    var onToCollapseAction: (() -> Void)?
    var onOpenAttachment: ((Attachment) -> Void)?
    var onRemovedAttachment: (() -> Void)?
    
    var subject: String? {
        get { return subjectDetailedView?.subject }
    }
    
    // MARK: - Subviews setup
    
    func setupSubviews() {
        backgroundColor = .white
        addFromDetailedView()
        addToDetailedView()
        addSubjectDetailedView()
        addBottomAttachmentsView()
    }
    
    func moveUp(to position: CGFloat) {
        toDetailedView?.frame.origin.y -= position
        moveSubjectUp(to: position)
    }
    
    func moveDown(to position: CGFloat) {
        toDetailedView?.frame.origin.y += position
        moveSubjectDown(to: position)
    }
    
    func moveSubjectDown(to position: CGFloat) {
        subjectDetailedView?.frame.origin.y += position
    }
    
    func moveSubjectUp(to position: CGFloat) {
        subjectDetailedView?.frame.origin.y -= position
    }
    
    func set(_ sender: SenderEmail) {
        fromDetailedView?.set(email: sender)
    }
    
    func append(_ attachment: Attachment) {
        attachmentsView?.frame.size.height = attachmentsViewHeight
        attachmentsView?.append(attachment)
    }
    
    func calculateToViewBottomPosition() -> CGFloat {
        if let toDetailedViewFrame = toDetailedView?.frame {
            return toDetailedViewFrame.size.height + toDetailedViewFrame.origin.y
        }
        return 0
    }
    
    func getAttachments() -> [Attachment] {
        if let attachments = attachmentsView?.getAttachments() {
            return attachments
        }
        return []
    }
    
    func isAttchmentsExist() -> Bool {
        guard let count = attachmentsView?.getAttachmentsCount() else { return false }
        if count > 0 {
            return true
        }
        return false
    }
    
    func removeAttachmentView() {
        attachmentsView?.frame.size.height = 0
    }
    
    // MARK: - Insertion and deletion of receivers logic
    
    func insertReceiver(at indexPath: IndexPath) {
        toDetailedView?.insertReceiver(at: indexPath)
    }
    
    func removeReceiver(at indexPath: IndexPath) {
        toDetailedView?.removeReceiver(at: indexPath)
    }
    
    func updatePlaceholder(at index: Int) {
        toDetailedView?.updatePlaceholder(for: index)
    }
    
    lazy private var onExpandButtonAction: () -> Void = { [weak self] in
        if self?.state == .expanded {
            self?.state = .collapsed
            self?.onExpandAction?(false)
//            self?.fromDetailedView?.changeExpandButton(to: false)
        } else if self?.state == .collapsed {
            self?.state = .expanded
            self?.onExpandAction?(true)
//            self?.fromDetailedView?.changeExpandButton(to: true)
        }
    }
    
    // MARK: - To detailed view creation
    
    private func addFromDetailedView() {
        guard fromDetailedView == nil else { return }
        let viewFrame = CGRect(x: 0, y: 0, width: screenWidth, height: viewHeight)
        
        fromDetailedView = FromDetailView(frame: viewFrame)
        fromDetailedView?.setupSubviews()
        
        if fromDetailedView != nil {
            addSubview(fromDetailedView!)
        }
    }
    
    private func addToDetailedView() {
        guard toDetailedView == nil else { return }
        let viewFrame = CGRect(x: 0, y: viewHeight, width: screenWidth, height: viewHeight)
        
        toDetailedView = ToDetailsView(frame: viewFrame)
        toDetailedView?.onExpandAction = onToExpandAction
        toDetailedView?.onCollapseAction = onToCollapseAction
        toDetailedView?.dataSource = toFieldDataSource
        toDetailedView?.delegate = toFieldDelegate
        toDetailedView?.setupSubviews()
        
        if toDetailedView != nil {
            addSubview(toDetailedView!)
        }
    }
    
    func addReceiver(_ receiver: EmailReceiver) {
//        toDetailedView?.append(receiver)
    }
    
    // MARK: - Subject details view creation
    
    private func addSubjectDetailedView() {
        guard subjectDetailedView == nil else { return }
        let viewFrame = CGRect(x: 0, y: 2*viewHeight, width: screenWidth, height: viewHeight)
        
        subjectDetailedView = SubjectDetailsView(frame: viewFrame)
        subjectDetailedView?.setupSubviews()
        
        if subjectDetailedView != nil {
            addSubview(subjectDetailedView!)
        }
    }
    
    private func addBottomAttachmentsView() {
        if attachmentsView != nil { return }
        let attachmentsViewFrame = CGRect(x: 0, y: 3 * viewHeight, width: screenWidth, height: 0)
        
        attachmentsView = AttachmentsView(frame: attachmentsViewFrame)
        attachmentsView?.shouldShowRemoveButton = true
        attachmentsView?.onOpenAttachment = onOpenAttachment
        attachmentsView?.onRemovedAttachment = onRemovedAttachment
        attachmentsView?.setupSubviews(for: nil, shouldDrawShadow: false)
        
        if attachmentsView != nil {
            addSubview(attachmentsView!)
        }
    }
}
