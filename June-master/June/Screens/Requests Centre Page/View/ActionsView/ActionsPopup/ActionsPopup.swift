//
//  CannedResposePopup.swift
//  June
//
//  Created by Oksana Hanailiuk on 9/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol ActionsPopupDelegate: class {
    func popup(_ popup: ActionsPopup, didSelectAction action: ReplyAction)
}

class ActionsPopup: UIViewController {

    var parentView = UIView()
    var tableView = UITableView()
    
    weak var delegate: ActionsPopupDelegate?
    var type: ActionsPopupType = .reply
    
    //UIInitializer
    lazy var uiInitializer: ActionsPopupUIInitializer = {
        let initializer = ActionsPopupUIInitializer(with: self)
        return initializer
    }()
    
    //Data repository
    lazy var dataRepository: ReplyActionsDataRepository = {
        var model: [ReplyAction] = []
        if type == .reply {
            model = replyModel()
        } else {
            model = cannedResponseModel()
        }
        let source = ReplyActionsDataRepository(with: model)
        return source
    }()
    
    //Data source
    lazy var listDataSource: ReplyActionsDataSource = {
        var source = ReplyActionsDataSource(with: dataRepository, and: type)
        return source
    }()
    
    //Delegate
    lazy var listDelegate: ReplyActionsDelegate = {
        var delegate = ReplyActionsDelegate(with: dataRepository, and: type)
        delegate.tableViewDidSelectRowAction = self.tableViewDidSelectRowAction
        return delegate
    }()
    
    lazy var tableViewDidSelectRowAction: ((Int, ReplyAction) -> Void) = { _, action in
        self.delegate?.popup(self, didSelectAction: action)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiInitializer.performBasicSetup()
        uiInitializer.layoutSubviews()
        uiInitializer.updateHeight(with: dataRepository.getCount(), and: type)
    }
    
    func addTopArrow() {
        uiInitializer.addTopArrow()
    }
    
    func addBottomArrow() {
        uiInitializer.addBottomArrow()
    }
    
    //private part
    private func cannedResponseModel() -> [ReplyAction] {
        let interested = ReplyAction(title: LocalizedStringKey.CannedResponseHelper.InterestedTitle, message: LocalizedStringKey.CannedResponseHelper.InterestedMessage)
        let maybeLater = ReplyAction(title: LocalizedStringKey.CannedResponseHelper.MaybeLaterTitle, message: LocalizedStringKey.CannedResponseHelper.MaybeLaterMessage)
        let noThanks = ReplyAction(title: LocalizedStringKey.CannedResponseHelper.NoThanksTitle, message: LocalizedStringKey.CannedResponseHelper.NoThanksMessage)
        return [interested, maybeLater, noThanks]
    }
    
    private func replyModel() -> [ReplyAction] {
        let reply = ReplyAction(title: LocalizedStringKey.RequestsViewHelper.ReplyTitle, imageName: LocalizedImageNameKey.RequestsViewHelper.ReplyPopupIconName)
        let cannedResponse = ReplyAction(title: LocalizedStringKey.RequestsViewHelper.CannedResponseTitle, imageName: LocalizedImageNameKey.RequestsViewHelper.CannedResponsePopupIconName)
        return [reply, cannedResponse]
    }
}

extension ActionsPopup: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let isDescendant = touch.view?.isDescendant(of: tableView) else { return true }
        if isDescendant {
            return false
        }
        return true
    }
}
