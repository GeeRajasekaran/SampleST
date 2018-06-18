//
//  TimestampsConverter.swift
//  June
//
//  Created by Ostap Holub on 12/28/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class TimestampsConverter {
    
    class func date(from timestamp: Int32) -> Date {
        let currentDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return start(of: currentDate)
    }
    
    class func start(of date: Date) -> Date {
        var currentCalendar = Calendar.current
        currentCalendar.timeZone = TimeZone.current
        return currentCalendar.startOfDay(for: date)
    }
    
    class func end(of date: Date) -> Date? {
        let startDate = start(of: date)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        
        var currentCalendar = Calendar.current
        currentCalendar.timeZone = TimeZone.current
        return currentCalendar.date(byAdding: components, to: startDate)
    }
    
}
