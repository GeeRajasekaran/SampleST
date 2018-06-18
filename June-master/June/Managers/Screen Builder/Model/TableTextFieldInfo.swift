//
//  TableTextFieldInfo.swift
//  June
//
//  Created by Joshua Cleetus on 11/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

class TableTextFieldInfo: BaseTableModel {
    
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
    var phoneMinChar: Int = 10
    var phoneMaxChar: Int = 12
    
    var _isValid: Bool {
        get {
            if isOptional {
                return true
            } else if _ignoreCharValidity {
                return false
            }
            var addV = true
            if additionalValidityRequired, let v = additionalValidity {
                addV = v
                if overrideValidityToAdditionalOnly {
                    return v
                }
            }
            return _value.count >= minChar && _value.count <= maxChar && addV
        }
    }
    
    var additionalValidityRequired: Bool = false
    var additionalValidity: Bool?
    var overrideValidityToAdditionalOnly: Bool = false
    
    var isOptional: Bool = false
    let optionalPlaceholder = "Optional"
    
    private var _ignoreCharValidity: Bool = false
    var ignoreCharValidity: Bool {
        get {
            return _ignoreCharValidity
        }
        set {
            _ignoreCharValidity = newValue
        }
    }
    
    var additionalPlaceholder: String = ""
    
//    var countrySetting: RomioSettingsCountry = RomioSettingsCountry.usa
//    var durationType: DurationType = DurationType.minute
//    var rateType: RateType = .session
    
    init(placeholder: String, possibleValueFromServer: String?, errorNote: String, maxChar: Int, minChar: Int, additionalValidityRequired: Bool = false) {
        self.placeholder = placeholder
        self.possibleValueFromServer = possibleValueFromServer
        self.errorNote = errorNote
        self.maxChar = maxChar
        self.minChar = minChar
        self.additionalValidityRequired = additionalValidityRequired
        super.init()
    }
}
