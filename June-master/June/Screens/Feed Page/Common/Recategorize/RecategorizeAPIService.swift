//
//  RecategorizeAPIService.swift
//  June
//
//  Created by Ostap Holub on 12/12/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class RecategorizeAPIService {
    
    // MARK: - Variables & Constants
    
    private let kCategory: String = "category"
    
    var onSuccessResponse: (() -> Void)?
    var onErrorResponse: ((FeedItem, String) -> Void)?
    
    // MARK: - Public methods
    
    func changeCategory(of item: FeedItem, toCategoryWith id: String) {
        guard isCategoryIdValid(id) else {
            print("\(#file).\(#line) Category id is empty, abort recategorization")
            return
        }
        guard let threadId = ThreadIdValidator.validate(threadId: item.id) else {
            return
        }
        
        let params = buildPatchParams(for: id)
        FeathersManager.Services.threads.request(.patch(id: threadId, data: params, query: nil))
            .on(value: { response in
                print(response)
        }).startWithFailed({ [weak self] error in
            self?.onErrorResponse?(item, error.localizedDescription)
        })
    }
    
    // MARK: - Private processing part
    
    private func isCategoryIdValid(_ id: String) -> Bool {
        return !id.isEmpty
    }
    
    private func buildPatchParams(for id: String) -> [String: Any] {
        return [kCategory: id]
    }
}
