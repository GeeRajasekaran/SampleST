//
//  TemplatesHandler.swift
//  June
//
//  Created by Ostap Holub on 1/24/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import Feathers
import SwiftyJSON

protocol ITemplateLoadable {
    func loadFeedTemplates()
}

protocol ITemplateReadable {
    func readTemplates() -> [FeedCardTemplate]?
}

class TemplatesHandler {

    // MARK: - Variables & Constants
    
    private let filename: String = "june_feed_template.json"
    
    // MARK: - File path fetching
    
    private var templatesPath: String? {
        get {
            guard let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
            return documentsDirectoryPath + "/\(filename)"
        }
    }
}

extension TemplatesHandler: ITemplateLoadable {
    
    // MARK: - Feathers request
    
    func loadFeedTemplates() {
        let query = Query().limit(50)
        
        FeathersManager.Services.template.request(.find(query: query))
            .on(value: { [weak self] response in
                let json = JSON(response.data.value)
                guard json.isEmpty == false else { return }
                self?.save(json: json)
            }).startWithFailed({ error in
                print(error.localizedDescription)
            })
    }
    
    // MARK: - Files saving logic
    
    private func save(json: JSON) {
        guard let finalPath = templatesPath else { return }
        save(json: json, at: finalPath)
    }
    
    private func save(json: JSON, at path: String) {
        guard let rawJsonString = json.rawString() else { return }
        do {
            try rawJsonString.write(toFile: path, atomically: true, encoding: .utf8)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
}

extension TemplatesHandler: ITemplateReadable {
    
    // MARK: - Files reading logic
    
    func readTemplates() -> [FeedCardTemplate]? {
        guard let path = templatesPath else { return nil }
        
        var rawJsonString: String?
        
        do {
            rawJsonString = try String(contentsOfFile: path, encoding: .utf8)
        } catch (let error) {
            print(error.localizedDescription)
        }
        
        if let unwrappedJsonString = rawJsonString, let array = JSON(parseJSON: unwrappedJsonString).array {
            return array.map { element in return FeedCardTemplate(json: element) }
        }
        return nil
    }
}
