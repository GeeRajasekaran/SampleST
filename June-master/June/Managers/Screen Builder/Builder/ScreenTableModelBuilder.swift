//
//  ScreenTableModelBuilder.swift
//  June
//
//  Created by Joshua Cleetus on 11/27/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

protocol ScreenTableModelProtocol: class {
    func updateModel(model: Any?, type: Any)
    func loadSections() -> [Any]
    func switchSegment(_ segment: Any)
    func loadSegment() -> Any
    func loadRows(withSection section: Any) -> [Any]
    func loadModel<T : RawRepresentable, Q : RawRepresentable>(for sectionType: T, rowType: Q, forPath indexPath: IndexPath) -> BaseTableModel
    func saveModel<T: RawRepresentable>(for rowType: T, model: BaseTableModel) -> BaseTableModel
    func filterData<T: RawRepresentable>(for rowType: T, data: [BaseTableModel])
    func loadFinalModel() -> Any
    var allInputFieldsValid: Bool { get }
}

class ScreenTableModelBuilder: ScreenTableModelProtocol {
    
    var allInputFieldsValid: Bool {
        get {
            return true
        }
    }

    init(model: Any? = nil) {
    }
    
    func updateModel(model: Any?, type: Any) {
        
    }

    func loadSections() -> [Any] {
        return []
    }
    
    func switchSegment(_ segment: Any) {
        
    }
    func loadSegment() -> Any {
        return (Any).self
    }
    
    func loadRows(withSection section: Any) -> [Any] {
        return []
    }
    
    func loadModel<T, Q>(for sectionType: T, rowType: Q, forPath indexPath: IndexPath) -> BaseTableModel where T : RawRepresentable, Q : RawRepresentable {
        return BaseTableModel()
    }
    
    func saveModel<T: RawRepresentable>(for rowType: T, model: BaseTableModel) -> BaseTableModel {
        return BaseTableModel()
    }
    

    func filterData<T>(for rowType: T, data: [BaseTableModel]) where T : RawRepresentable {
        
    }
    
    func loadFinalModel() -> Any {
        return NSObject()
    }
}
