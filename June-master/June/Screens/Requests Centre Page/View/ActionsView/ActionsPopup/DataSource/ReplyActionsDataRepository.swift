//
//  ReplyActionsDataRepository
//  June
//
//  Created by Oksana Hanailiuk on 10/6/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class ReplyActionsDataRepository: NSObject {
    
    // MARK: - Variables
    private var actions: [ReplyAction]?
    
    //MARK: - UIInitializer
    init(with actions: [ReplyAction]?) {
        self.actions = actions
    }
    
    //MARK: - getting
    func getCount() -> Int {
        if let count = actions?.count {
            return count
        } else {
            return 0
        }
    }
    
    func getAction(by index: Int) -> ReplyAction? {
        return actions?[index]
    }
}
