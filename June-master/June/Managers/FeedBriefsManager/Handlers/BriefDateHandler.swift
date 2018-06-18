//
//  BriefDateHandler.swift
//  June
//
//  Created by Ostap Holub on 1/25/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

import Foundation

class BriefDateHandler {
    
    // MARK: - Variables & constants
    
    private var calendar: Calendar
    
    // MARK: - Initialization
    
    init() {
        calendar = Calendar.current
        calendar.timeZone = TimeZone.current
    }
    
    // MARK: - Morning brief time range
    
    func morningBriefTimeRange() -> (Int32, Int32)? {
        guard let end = endDate(), let start = startDate() else { return nil }
        return (Int32(start.timeIntervalSince1970), Int32(end.timeIntervalSince1970))
    }
    
    // MARK: - Morning brief range date calculations
    
    private func endDate() -> Date? {
        let currentDateMidnight = Date().midnight()
        return calendar.date(byAdding: .hour, value: 8, to: currentDateMidnight)
    }
    
    private func startDate() -> Date? {
        let currentDateMidnight = Date().midnight()
        return calendar.date(byAdding: .hour, value: -16, to: currentDateMidnight)
    }
}
