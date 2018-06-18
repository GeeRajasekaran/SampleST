//
//  RequestsScreenType.swift
//  June
//
//  Created by Oksana Hanailiuk on 1/10/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

enum RequestsScreenType: Int {
    case people = 0
    case subscriptions
    case blockedPeople
    case blockedSubscriptions
    
    static let screenTypes = [people, subscriptions, blockedPeople, blockedSubscriptions]
    
    static func create(from listItem: String?, and status: String?) -> RequestsScreenType? {
        if status == Status.blocked.value {
            return createBlockedType(from: listItem)
        } else if status == Status.unblock.value {
            return createPendingType(from: listItem)
        } else if status == nil {
             return createPendingType(from: listItem)
        }
        return nil
    }
    
    private static func createPendingType(from listItem: String?) -> RequestsScreenType? {
        if listItem == "people" {
            return .people
        } else if listItem == "subscriptions" {
            return .subscriptions
        }
        return nil
    }
    
    private static func createBlockedType(from listItem: String?) -> RequestsScreenType? {
        if listItem == "people" {
            return .blockedPeople
        } else if listItem == "subscriptions" {
            return .blockedSubscriptions
        }
        return nil
    }
}
