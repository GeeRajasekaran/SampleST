//
//  TableTextViewInfo.swift
//  June
//
//  Created by Joshua Cleetus on 11/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//


class TableTextViewInfo: BaseTableModel {

    let placeholder: String
    var _isSet: Bool = false
    var valueHolder: String = "" {
        didSet {
            _isSet = true
        }
    }
    var _value: String {
        get {
            if _isSet {
                return valueHolder
            }
            if let possibleValue = self.possibleValueFromServer {
                if !_isSet {
                    valueHolder = possibleValue
                }
                return possibleValue
            }
            return ""
        }
        set {
            _ignoreCharValidity = false
            valueHolder = newValue
        }
    }
    var possibleValueFromServer: String?
    
    var maxChar: Int
    var minChar: Int = 3
    var errorNote: String
    var keyboardType: UIKeyboardType = .default
    
    var charRemaining: String = ""
    var charRemainingText: String {
        get {
            return String(charCount) + " " + self.charRemaining 
        }
    }
    var _isValid: Bool {
        get {
            if isOptional {
                return true
            } else if _ignoreCharValidity {
                return false
            }
            return _value.count >= minChar && _value.count <= maxChar
        }
    }
    
    var charCount: Int {
        get {
            return maxChar - _value.count
        }
    }
    
    var header: String
    var isOptional: Bool = false
    
    private var _ignoreCharValidity: Bool = false
    var ignoreCharValidity: Bool {
        get {
            return _ignoreCharValidity
        }
        set {
            _ignoreCharValidity = newValue
        }
    }

    var clearButtonTitle = "Clear"
    
    
    init(placeholder: String, possibleValueFromServer: String?, errorNote: String, maxChar: Int, minChar: Int, header: String = "") {
        self.placeholder = placeholder
        self.possibleValueFromServer = possibleValueFromServer
        self.errorNote = errorNote
        self.maxChar = maxChar
        self.minChar = minChar
        self.header = header
        super.init()
    }
}
