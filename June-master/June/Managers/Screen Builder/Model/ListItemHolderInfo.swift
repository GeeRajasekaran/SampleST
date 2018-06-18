//
//  ListItemHolderInfo.swift
//  June
//
//  Created by Joshua Cleetus on 11/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

class ListItemHolderInfo: BaseTableModel {
    
    var placeHolder: String
    var _value: String {
        get {
            if let s = selectedItem, s.count > 0 {
                return s
            }
            return placeHolder
        }
    }
    var selectedItem: String? {
        didSet {
            if let item = selectedItem {
                if !item.trimmingCharacters(in: .whitespaces).isEmpty {
                    _ignoreSelectedValidity = false
                }
            }
        }
    }
    var id: String?
    
    var errorNote: String
    
    var ignoreId: Bool = false
    var selected: Bool {
        get {
            if _ignoreSelectedValidity {
                return false
            }
            
            if let item = selectedItem {
                if ignoreId {
                    return item.count > 0
                } else if let i = self.id {
                    return item.count > 0 && i.count > 0
                }
            }
            return false
        }
    }
    
    private var _ignoreSelectedValidity: Bool = false
    var ignoreSelectedValidity: Bool {
        get {
            return _ignoreSelectedValidity
        }
        set {
            _ignoreSelectedValidity = newValue
        }
    }
    
    init(placeHolder: String, selectedItem: String?, id: String?, errorNote: String) {
        self.placeHolder = placeHolder
        self.errorNote = errorNote
        self.selectedItem = selectedItem
        self.id = id
        super.init()
    }
}
