//
//  DatabaseEntity.swift
//  June
//
//  Created by Joshua Cleetus on 12/22/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

enum DatabaseEntity: String {
    case cards = "Cards"
    case lastMessageFrom = "LastMessageFrom"
    case lastMessageTo = "LastMessageTo"
    case messages = "Messages"
    case messages_Bcc = "Messages_Bcc"
    case messages_Cc = "Messages_Cc"
    case messages_Events = "Messages_Events"
    case messages_Events_Participants = "Messages_Events_Participants"
    case messages_Events_When = "Messages_Events_When"
    case messages_Files = "Messages_Files"
    case messages_Forwarded_From = "Messages_Forwarded_From"
    case messages_Forwarded_To = "Messages_Forwarded_To"
    case messages_From = "Messages_From"
    case messages_Reply_To = "Messages_Reply_To"
    case messages_Segmented_Html = "Messages_Segmented_Html"
    case messages_Segmented_Pro = "Messages_Segmented_Pro"
    case messages_To = "Messages_To"
    case messages_Unsubscribe_Links = "Messages_Unsubscribe_Links"
    case participants = "Participants"
    case threads = "Threads"
    case threadsEvents = "ThreadsEvents"
    case threadsEventsParticipants = "ThreadsEventsParticipants"
    case vendor = "Vendor"
}
