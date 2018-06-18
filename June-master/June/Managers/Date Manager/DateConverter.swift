//
//  DateConverter.swift
//  June
//
//  Created by Ostap Holub on 8/23/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class DateConverter {
    
    // MARK: - Variables & constants
    
    private var currentCalendar: Calendar
    private let agoString = LocalizedStringKey.FeedViewHelper.AgoStringTitle
    
    private struct ComponentName {
        static let hours = "h"
        static let days = "d"
        static let minutes = "m"
        static let weeks = "w"
        static let years = "y"
    }
    
    private struct Constants {
        static let countOfHoursInDay = 24
        static let countOfDaysInWeek = 7
        static let countOfWeeksInYear = 52
    }
    
    // MARK: - Initialization
    
    init() {
        currentCalendar = Calendar.current
    }
    
    // MARK: - Public part
    
    func timeInWords(from date: Date) -> String {
        
        let hoursDiff = hours(from: date)
        if hoursDiff >= 1 {
            return formattedHours(hoursDiff)
        } else {
            let minutesDiff = minutes(from: date)
            return formattedMinutes(minutesDiff)
        }
    }
    
    // MARK: - Private calculations part
    
    private func hours(from date: Date) -> Int {
        let currentDate = Date()
        let components = currentCalendar.dateComponents([.hour], from: date, to: currentDate)
        if let hours = components.hour {
            return hours
        }
        return 0
    }
    
    private func minutes(from date: Date) -> Int {
        let currentDate = Date()
        let components = currentCalendar.dateComponents([.minute], from: date, to: currentDate)
        if let minutes = components.minute {
            return minutes
        }
        return 0
    }
    
    // MARK: - Private formatting part
    
    private func formattedHours(_ hours: Int) -> String {
        if hours / Constants.countOfHoursInDay >= 1 {
            return formattedDays(Int(hours / Constants.countOfHoursInDay))
        }
        return String(hours) + ComponentName.hours + agoString
    }
    
    private func formattedMinutes(_ minutes: Int) -> String {
        return String(minutes) + ComponentName.minutes + agoString
    }
    
    private func formattedDays(_ days: Int) -> String {
        if days / Constants.countOfDaysInWeek >= 1 {
            return formattedWeeks(Int(days / Constants.countOfDaysInWeek))
        }
        return String(days) + ComponentName.days + agoString
    }
    
    private func formattedWeeks(_ weeks: Int) -> String {
        if weeks / Constants.countOfWeeksInYear >= 1 {
            return formattedYears(Int(weeks / Constants.countOfWeeksInYear))
        }
        return String(weeks) + ComponentName.weeks + agoString
    }
    
    private func formattedYears(_ years: Int) -> String {
        return String(years) + ComponentName.years + agoString
    }
    
}
