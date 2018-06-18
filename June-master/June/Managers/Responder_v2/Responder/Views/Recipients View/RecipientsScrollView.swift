//
//  RecipientsScrollView.swift
//  June
//
//  Created by Ostap Holub on 2/22/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class RecipientsScrollView: UIScrollView {
    
    private struct Constant {
        static let leading: CGFloat = 15
    }
    
    private var recipientViews: [RecipientItemView] = []
    weak var dataRepository: ResponderRecipientsDataRepository?
    var onRemoveAction: ((EmailReceiver) -> Void)?
    
    func populateRecipients() {
        isUserInteractionEnabled = true
        isScrollEnabled = true
        showsHorizontalScrollIndicator = false
        guard let recipients = dataRepository?.recipients else { return }
        for (index, recipient) in recipients.enumerated() {
            let rect = initialRect(at: index)
            let recipientView = RecipientViewBuilder.view(for: recipient, with: rect)
            recipientView.removeAction = onRemoveAction
            addSubview(recipientView)
            recipientViews.append(recipientView)
        }
        updateContentSize()
    }
    
    func addRecipient(_ recipient: EmailReceiver) {
        let rect = insertedViewRect()
        let recipientView = RecipientViewBuilder.view(for: recipient, with: rect)
        recipientView.removeAction = onRemoveAction
        insert(view: recipientView)
        addSubview(recipientView)
        updatePositionOfInputView()
        updateContentSize()
    }
    
    func removeRecipient(_ recipient: EmailReceiver) {
        guard let index = dataRepository?.index(of: recipient) else { return }
        if 0..<recipientViews.count ~= index {
            recipientViews[index].removeFromSuperview()
            recipientViews.remove(at: index)
        }
        updateAllViewsPositions()
    }
    
    // MARK: - View rects calculations
    
    private func updateContentSize() {
        var contentWidth: CGFloat = Constant.leading * 2 + Constant.leading * CGFloat(recipientViews.count - 1)
        recipientViews.forEach { view in
            contentWidth += view.frame.width
        }
        contentSize = CGSize(width: contentWidth, height: frame.height)
    }
    
    private func initialRect(at index: Int) -> CGRect {
        var originX: CGFloat = 0
        if index == 0 {
            originX = Constant.leading
        } else {
            let view = recipientViews[index - 1]
            originX = view.frame.origin.x + view.frame.width + Constant.leading
        }
        
        let height: CGFloat = frame.height - UIView.midMargin
        let originY: CGFloat = frame.height / 2 - height / 2
        return CGRect(x: originX, y: originY, width: 0, height: height)
    }
    
    private func insertedViewRect() -> CGRect {
        var originX: CGFloat = Constant.leading
        if let previousView = lastView() {
            originX = previousView.frame.origin.x + previousView.frame.width + Constant.leading
        }
        let height: CGFloat = frame.height - UIView.midMargin
        let originY: CGFloat = frame.height / 2 - height / 2
        return CGRect(x: originX, y: originY, width: 0, height: height)
    }
    
    private func lastView() -> UIView? {
        if recipientViews.count == 1 {
            return nil
        }
        return recipientViews[recipientViews.count - 2]
    }
    
    // MARK: - All recipients views updating
    
    private func updateAllViewsPositions() {
        for (index, view) in recipientViews.enumerated() {
            let rect = initialRect(at: index)
            let finalRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: view.frame.width, height: rect.height)
            view.frame = finalRect
        }
    }
    
    func scrollToLastItem() {
        guard recipientViews.count > 2 else { return }
        let offset: CGFloat = contentSize.width - bounds.width
        setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
    
    func addPlaceholder() {
        guard let lastView = recipientViews.last as? InputRecipientItemView else { return }
        lastView.addPlaceholder()
    }
    
    func addPlaceholderIfNeeded() {
        if recipientViews.count == 1 {
            addPlaceholder()
        }
    }
    
    // MARK: - Input receiver view updating
    
    private func insert(view: RecipientItemView) {
        let index = recipientViews.count - 1
        if index < recipientViews.count {
            recipientViews.insert(view, at: index)
        }
    }
    
    private func updatePositionOfInputView() {
        guard let inputView = recipientViews.last else { return }
        guard let previousView = lastView() else { return }
        
        inputView.frame.origin.x = previousView.frame.origin.x + previousView.frame.width + Constant.leading
    }
}
