//
//  ResponderNavigationCoordinator.swift
//  June
//
//  Created by Ostap Holub on 2/21/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class ResponderNavigationCoordinator: IResponderNavigationCoordinator {
    
    private weak var controller: UIViewController?
    
    func show(suggestions: IContactsSuggestionsViewController & UIViewController, for metadata: ResponderMetadata, at rootVC: UIViewController) {
        let suggestionsFrame = frame(for: metadata)
        
        suggestions.view.frame = suggestionsFrame
        suggestions.view.backgroundColor = .clear
        rootVC.view.addSubview(suggestions.view)
        controller = suggestions
    }
    
    func hideSuggestions() {
        controller?.view.removeFromSuperview()
    }
    
    private func frame(for metadata: ResponderMetadata) -> CGRect {
        if metadata.state == .regular {
            let frame =  CGRect(x: 0, y: metadata.frame.origin.y - ResponderLayoutConstants.Height.suggestions, width: UIScreen.main.bounds.width, height: ResponderLayoutConstants.Height.suggestions)
            return frame
        } else if metadata.state == .expanded {
            let frame = CGRect(x: 0, y: metadata.frame.origin.y + ResponderLayoutConstants.Header.height, width: UIScreen.main.bounds.width, height: ResponderLayoutConstants.Height.suggestions)
            return frame
        }
        return .zero
    }
}
