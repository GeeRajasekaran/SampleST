//
//  FeedBriefsManager.swift
//  June
//
//  Created by Ostap Holub on 1/25/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedBriefsManager {
    
    // MARK: - Variables & Constants
    
    private var preferencesHandler: FeedPreferencesHandler = FeedPreferencesHandler()
    private var dataLoader: BriefDataLoader = BriefDataLoader()
    
    private lazy var preferencesListener: FeedPreferencesRealtimeListener = { [weak self] in
        let listener = FeedPreferencesRealtimeListener(action: self?.onEvent)
        return listener
    }()
    
    var currentBrief: IFeedBrief?
    private var onBriefLoadingFinished: ((IFeedBrief) -> Void)?
    
    // MARK: - Initialization
    
    init(onLoad: ((IFeedBrief) -> Void)?) {
        onBriefLoadingFinished = onLoad
        preferencesListener.subscribe()
    }
    
    // MARK: - Brief data loading
    
    func requestMorningBrief() {
//        dataLoader.loadBrief(with: preferencesHandler.briefCategories, completion: onBriefLoaded)
    }
    
    private lazy var onBriefLoaded: (IFeedBrief) -> Void = { [weak self] brief in
//        self?.currentBrief = brief
//        self?.onBriefLoadingFinished?(brief)
    }
    
    // MARK: - Actions
    
    private lazy var onEvent: () -> Void = { [weak self] in
//        self?.preferencesHandler.loadBriefCategories()
//        self?.requestMorningBrief()
    }
    
}
