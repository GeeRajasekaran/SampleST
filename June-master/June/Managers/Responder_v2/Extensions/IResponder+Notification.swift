//
//  IResponder+Notification.swift
//  June
//
//  Created by Ostap Holub on 2/14/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    // MARK: - Custom notifications for Responder actions
    
    static let onExpandClicked = Notification.Name(rawValue: "ResponderOnExpandClicked")
    static let onSendClicked = Notification.Name(rawValue: "ResponderOnSendClicked")
    static let onAttachClicked = Notification.Name(rawValue: "ResponderOnAttachClicked")
    static let onAttachmentRemoved = Notification.Name(rawValue: "ResponderOnAttachmentRemoved")
    static let onAttachmentOpened = Notification.Name(rawValue: "ResponderOnAttachmentOpened")
    static let onThumbsUpClicked = Notification.Name(rawValue: "ResponderOnThumbsUpClicked")
    
    static let onMinimizedViewClicked = Notification.Name(rawValue: "ResponderOnMinimizedViewClicked")
    
    // MARK: - Custom notifications for metadata changes
    
    static let onMessageChanged = Notification.Name(rawValue: "ResponderMessageChanged")
    static let onFrameChanged = Notification.Name(rawValue: "ResponderFrameChanged")
    
    // MARK: - Autocomplete contacts search
    
    static let onQueryChanged = Notification.Name(rawValue: "ResponderAutocompleteSearchQueryChanged")
    static let onSearchFinished = Notification.Name(rawValue: "ResponderAutocompleteSearchFinished")
    static let onSearchStarted = Notification.Name(rawValue: "ResponderAutocompleteSearchStarted")
    static let onClearTextInput = Notification.Name(rawValue: "ResponderClearSearchInputText")
    
    static let onAddRecipient = Notification.Name(rawValue: "ResponderOnRecipientAdded")
    
    // MARK: - Responder API Engine notifications
    
    static let onSuccessResponse = Notification.Name(rawValue: "ResponderOnSuccessResponse")
    static let onFailedResponse = Notification.Name(rawValue: "ResponderOnFailedResponse")
    
    // MARK: - Responder attachments uploading notificaitons
    
    static let onStartUploading = Notification.Name(rawValue: "ResponderAttachmentsLoadingStarted")
    static let onStopUploading = Notification.Name(rawValue: "ResponderAttachmentsLoadingSStopped")
    static let onRemoveRecipientByBackspace = Notification.Name(rawValue: "RecipientRemovedByBackspace")
    
    static let sendButtonCheck = Notification.Name(rawValue: "ResponderSendButtonCheck")
}
