//
//  IResponderActionsListener.swift
//  June
//
//  Created by Ostap Holub on 2/12/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

protocol IResponderActionsListener {
    
    /// Method that will be called after click on send action
    func onSendAction(_ metadata: ResponderMetadata)
    /// Method that will be called after success server response
    func onSuccessAction(_ responseData: [String: AnyObject])
    /// Method that will be called after failed server response
    func onFailAction(_ error: String)
    /// Method that will be called after hiding the Responder
    func onHideAction(_ metadata: ResponderMetadata, shouldSaveDraft: Bool)
    /// Method that will be called everytime when frame changed
    func onChangeFrame(_ responderFrame: CGRect)
}

extension IResponderActionsListener {
    
    func onSendAction(_ metadata: ResponderMetadata) {}
    
    func onSuccessAction(_ responseData: [String: AnyObject]) {}
    
    func onFailAction(_ error: String) {}
    
    func onHideAction(_ metadata: ResponderMetadata, shouldSaveDraft: Bool) {}
    
    func onChangeFrame(_ responderFrame: CGRect) {}

}
