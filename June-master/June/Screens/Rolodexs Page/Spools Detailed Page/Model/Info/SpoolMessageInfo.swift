//
//  SpoolMessageInfo.swift
//  June
//
//  Created by Ostap Holub on 4/3/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation
import Down

class SpoolMessageInfo: BaseTableModel {
    
    // MARK: - Variables & Constants
    
    private var message: Messages?
    private var markdownString: String?
    
    // MARK: - Initialization
    
    init(message: Messages) {
        self.message = message
        super.init()
        prepareDown()
    }
    
    // MARK: - Properties getters
    
    var title: String? {
        return message?.snippet
    }
    
    var id: String? {
        return message?.id
    }
    
    var profileIconUrl: URL? {
        return loadProfileIconUrl()
    }
    
    var senderName: String? {
        if sender()?.name == "" {
            return sender()?.email
        }
        return sender()?.name
    }
    
    var date: Int32? {
        return message?.date
    }
    
    var body: String? {
        if markdownString == nil {
            return loadMarkdown() ?? message?.body
        }
        return markdownString
    }
    
    // MARK: - Private markdown loading
    
    private func loadMarkdown() -> String? {
        guard let objects = message?.messages_segmented_html?.allObjects as? [Messages_Segmented_Html] else { return nil }
        if let segmentedHtml = objects.first(where: { $0.order == 1 && $0.type == "top_message" }) {
            if let markdown = segmentedHtml.html_markdown {
                return markdown
            } else {
                return segmentedHtml.html
            }
        }
        return nil
    }
    
    private func prepareDown() {
        guard let inputHtml = loadMarkdown() ?? message?.body else { return }
        let down = Down(markdownString: inputHtml)
        do {
            let html = try down.toHTML()
            let font = "<font face='Lato' size='15' color='black'>"
            markdownString = font + html
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Private profile URL fetching
    
    private func loadProfileIconUrl() -> URL? {
        if let firstPerson = sender(), let urlString = firstPerson.profile_pic {
            return URL(string: urlString)
        }
        return nil
    }
    
    // MARK: - Sender name fetching
    
    private func sender() -> Messages_From? {
        guard let fromArray = message?.messages_from?.sortedArray(using: []) as? [Messages_From] else { return nil }
        return fromArray.first
    }
}
