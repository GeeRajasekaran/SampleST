//
//  CannedResponseDelegate.swift
//  June
//
//  Created by Oksana Hanailiuk on 10/6/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ReplyActionsDelegate: NSObject {
    
    let screenWidth = UIScreen.main.bounds.width
    var dataStorage: ReplyActionsDataRepository?
    var type: ActionsPopupType = .reply
    
    var tableViewDidSelectRowAction: ((Int, ReplyAction) -> Void)?
    
    // MARK: - Initialization
    init(with storage: ReplyActionsDataRepository?, and type: ActionsPopupType) {
        dataStorage = storage
        self.type = type
        super.init()
    }
}

extension ReplyActionsDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if type == .cannedResponse {
            let view = CannedResponseHeaderView()
            view.setupSubviews(with: LocalizedStringKey.RequestsViewHelper.CannedResponseTitle)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if type == .cannedResponse {
            return 0.056 * screenWidth
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.104 * screenWidth
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let replyAction = dataStorage?.getAction(by: indexPath.row) else { return }
        tableViewDidSelectRowAction?(indexPath.row, replyAction)
    }
}
