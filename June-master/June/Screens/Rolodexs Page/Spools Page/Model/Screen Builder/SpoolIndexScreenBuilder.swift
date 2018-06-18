//
//  SpoolIndexScreenBuilder.swift
//  June
//
//  Created by Ostap Holub on 3/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class SpoolIndexScreenBuilder: ScreenTableModelBuilder {
    
    // MARK: - Variables & Constants
    
    var dataRepository: SpoolsDataRepository
    var headerInfo: SpoolIndexHeaderInfo?
    
    // MARK: - Initializtion
    
    override init(model: Any?) {
        dataRepository = SpoolsDataRepository()
        super.init(model: model)
        guard let rolodex = model as? Rolodexs else { return }
        headerInfo = SpoolIndexHeaderInfo(rolodex: rolodex)
    }
    
    override func updateModel(model: Any?, type: Any) {
        guard let spools = model as? [Spools] else { return }
        dataRepository.update(with: spools.map { element in
            return SpoolItemInfo(spool: element)
        })
    }
    
    override func loadRows(withSection section: Any) -> [Any] {
        return SpoolsRowType.rowTypes(from: dataRepository.spoolItems)
    }
    
    override func loadModel<T, Q>(for sectionType: T, rowType: Q, forPath indexPath: IndexPath) -> BaseTableModel where T : RawRepresentable, Q : RawRepresentable {
        guard 0..<dataRepository.count ~= indexPath.section else { return BaseTableModel() }
        return dataRepository.spoolItems[indexPath.section]
    }
}
