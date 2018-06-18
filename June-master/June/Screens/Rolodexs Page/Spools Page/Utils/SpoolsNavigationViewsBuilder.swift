//
//  SpoolsNavigationViewsBuilder.swift
//  June
//
//  Created by Ostap Holub on 4/6/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

enum SpoolNavigationViewType {
    case profile
    case details
}

class SpoolsNavigationViewsBuilder {
    
    // MARK: - Variables & Constants
    
    private var target: Any
    private var selector: Selector
    
    // MARK: - Initialization
    
    init(target: Any, action: Selector) {
        self.target = target
        self.selector = action
    }
    
    func navigationView(for type: SpoolNavigationViewType) -> [UIBarButtonItem] {
        var items: [UIBarButtonItem] = []
        items.append(createBackButton())
        
        if type == .profile {
            items.append(createProfileViewItem())
        } else if type == .details {
            items.append(createDetailsViewItem())
        }
        return items
    }
    
    // MARK: - Back button building logic
    
    private func createBackButton() -> UIBarButtonItem {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        backButton.addTarget(target, action: selector, for: .touchUpInside)
        
        let image = UIImage(named: "spools_back_button")?.imageResize(sizeChange: CGSize(width: 10, height: 18))
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        backButton.setImage(image, for: .normal)
        return UIBarButtonItem(customView: backButton)
    }
    
    // MARK: - Info views building logic
    
    private func createProfileViewItem() -> UIBarButtonItem {
        let view = SpoolIndexLeftNavBarView()
        view.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        view.setupSubviews()
        return UIBarButtonItem(customView: view)
    }
    
    private func createDetailsViewItem() -> UIBarButtonItem {
        let view = SpoolDetailsLeftNavBarView()
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        view.setupSubviews()
        return UIBarButtonItem(customView: view)
    }
}
