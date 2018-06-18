//
//  RequestsButtonsView.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/19/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import UIKit

class RequestsButtonsView: UIView {
    var onApprovedTapped: ((UISelectableButton) -> Void)?
    var onIgnoredTapped: ((UISelectableButton) -> Void)?
    var onBlockedTapped: ((UISelectableButton) -> Void)?
    var onDeniedTapped: ((UISelectableButton) -> Void)?
    var onUnblockedTapped: ((UISelectableButton) -> Void)?
    
    func setupSubviews() {
        backgroundColor = .white
    }
}
