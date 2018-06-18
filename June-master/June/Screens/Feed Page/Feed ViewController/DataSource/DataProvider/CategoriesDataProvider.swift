//
//  CategoriesDataProvider.swift
//  June
//
//  Created by Ostap Holub on 8/19/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

class CategoriesDataProvider {
    
    private let idsToRemove = ["conversations", "uncategorized"]
    
    // MARK: - Request section
    
    func requestCategories(completion: @escaping (Result<[FeedCategory]>) -> Void) {
        FeathersManager.Services.categories.request(.find(query: nil))
            .on(value: { response in
                if let array = JSON(response.data.value).array {
                    var categories = self.process(categories: array)
                    self.idsToRemove.forEach { [weak self] singleId in
                        guard let ids = self?.idsToRemove else { return }
                        if let index = categories.index(where: { ids.contains($0.id) }) {
                            categories.remove(at: index)
                        }
                    }
                    completion(.Success(categories))
                }
            }).startWithFailed({ error in
                completion(.Error(error.localizedDescription))
            })
    }
    
    // MARK: - Processing section
    
    func process(categories json: [JSON]) -> [FeedCategory] {
        return json.compactMap({ jsonObject in
            let category = FeedCategory(with: jsonObject)
            return category
        })
    }
    
}
