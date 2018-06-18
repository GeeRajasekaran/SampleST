//
//  RecategorizeActionSheetHadler.swift
//  June
//
//  Created by Ostap Holub on 12/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class RecategorizeActionSheetHandler {
    
    // MARK: - Variables & Constants
    
    private let kTitle: String = "_attributedTitle"
    private let convoId: String = "conversations"
    
    private let convoCategory = FeedCategory(id: "conversations", title: LocalizedStringKey.RecategorizeHelper.conversationTitle)
    
    private unowned var presentingViewController: UIViewController
    private var categories: [FeedCategory]
    private var actionsMap: [UIAlertAction: FeedCategory] = [UIAlertAction: FeedCategory]()
    private var actionSheet: UIAlertController?
    var onSelectCategory: ((FeedCategory) -> Void)?
    
    // MARK: - Initialization
    
    init(presentingVC: UIViewController, categories: [FeedCategory]) {
        presentingViewController = presentingVC
        self.categories = categories
    }
    
    // MARK: - Showing functionality
    
    func show(for thread: Threads) {
        let item = FeedItem(with: thread, category: convoCategory)
        show(for: item)
    }
    
    func show(for item: FeedItem) {
        addConversationsCategory()
        actionSheet = initializeActionSheet(for: item)
        if let unwrappedActionSheet = actionSheet {
            if let presentedVC = presentingViewController.presentedViewController {
                presentedVC.present(unwrappedActionSheet, animated: true, completion: nil)
            } else {
                presentingViewController.present(unwrappedActionSheet, animated: true, completion: nil)
            }
        }
    }
    
    func hide() {
        actionSheet?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private initialization logic
    
    private func addConversationsCategory() {
        if !categories.contains(convoCategory) {
            categories.insert(convoCategory, at: 0)
        }
    }
    
    private func initializeActionSheet(for item: FeedItem) -> UIAlertController {
        let actions = buildActions(for: categories, with: item)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.setValue(buildTitle(for: item), forKey: kTitle)
        actions.forEach { action in
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: LocalizedStringKey.RecategorizeHelper.cancelTitle, style: .cancel, handler: onCancelTriggered)
        actionSheet.addAction(cancelAction)
        return actionSheet
    }
    
    // MARK: - Title building logic
    
    private func buildTitle(for item: FeedItem) -> NSAttributedString {
        guard let categoryTitle = item.feedCategory?.title else {
            return NSAttributedString()
        }
        
        let finalPlainString = "\(LocalizedStringKey.RecategorizeHelper.titleFirstPart) \(categoryTitle)"
        let attributedString = NSMutableAttributedString(string: finalPlainString)
        
        guard let rangeOfCategoryTitle = finalPlainString.range(of: categoryTitle) else {
            return NSAttributedString()
        }
        let range = finalPlainString.nsRange(from: rangeOfCategoryTitle)
        let firstPartRange = NSRange(location: 0, length: LocalizedStringKey.RecategorizeHelper.titleFirstPart.count)
        let fullRange = NSRange(location: 0, length: finalPlainString.count)
        let font = UIFont(name: LocalizedFontNameKey.RecategorizeHelper.titleFont, size: 14)
        
        attributedString.addAttribute(.font, value: font as Any, range: fullRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.recategorizeTitleLightGray, range: firstPartRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.recategorizeTitleDarkGray, range: range)
        return attributedString
    }
    
    // MARK: - Actions building logic
    
    private func buildActions(for categories: [FeedCategory], with item: FeedItem) -> [UIAlertAction] {
        var actions = [UIAlertAction]()
        
        categories.forEach { [weak self] singleCategory in
            if singleCategory == item.feedCategory { return }
            if let unwrappedAction = self?.action(for: singleCategory) {
                actionsMap[unwrappedAction] = singleCategory
                actions.append(unwrappedAction)
            }
        }
        return actions
    }
 
    private func action(for category: FeedCategory) -> UIAlertAction {
        return UIAlertAction(title: category.title, style: .default, handler: onActionTriggered)
    }
    
    // MARK: - Actions handling
    
    private lazy var onActionTriggered: (UIAlertAction) -> Void = { [weak self] action in
        if let category = self?.actionsMap[action] {
            self?.onSelectCategory?(category)
        }
    }
    
    private lazy var onCancelTriggered: (UIAlertAction) -> Void = { [weak self] _ in
        self?.actionsMap.removeAll()
    }
}
