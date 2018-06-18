//
//  SpoolsDataProvider.swift
//  June
//
//  Created by Ostap Holub on 3/30/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import SwiftyJSON

class SpoolsDataProvider {
    
    // MARK: - Variables & Constants
    
    private var onSpoolsLoaded: (() -> Void)?
    private var spoolsProxy: SpoolsProxy = SpoolsProxy()
    
    // MARK: - Initialization
    
    init(onLoad: (() -> Void)?) {
        onSpoolsLoaded = onLoad
    }
    
    // MARK: - Public request logic
    
    func requestsSpools(by rolodexIds: [String]) {
        let query = Query()
            .in(property: "last_message_rolodex_id", values: rolodexIds)
            .sort(property: "last_message_date", ordering: .orderedDescending)
        
        FeathersManager.Services.spools.request(.find(query: query))
            .on(value: { [weak self] response in
                if let array = JSON(response.data.value).array {
                    self?.saveSpools(array)
                }
            }).startWithFailed({ error in
                print(error)
        })
    }
    
    // MARK: - Private saving logic
    
    private func saveSpools(_ json: [JSON]) {
        json.forEach { [weak self] singleSpool in
            self?.saveSpool(singleSpool)
        }
        spoolsProxy.saveContext()
        onSpoolsLoaded?()
    }
    
    private func saveSpool(_ spoolJson: JSON) {
        guard let spoolId = spoolJson["id"].string else { return }
        if let entity = spoolsProxy.fetchSpool(by: spoolId) {
            SpoolsParser.load(data: spoolJson, into: entity)
        } else {
            let entity = spoolsProxy.addNewSpool()
            SpoolsParser.load(data: spoolJson, into: entity)
        }
    }
}
