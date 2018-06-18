//
//  RecipientInputTextField.swift
//  June
//
//  Created by Ostap Holub on 3/6/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol RecipientInputTextFieldDelegate: class {
    func didDeleteBackward(_ textField: UITextField)
}

class RecipientInputTextField: UITextField {

    weak var deleteDelegate: RecipientInputTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        deleteDelegate?.didDeleteBackward(self)
    }
}
