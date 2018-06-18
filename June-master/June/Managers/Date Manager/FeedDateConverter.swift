//
//  FeedDateConverter.swift
//  June
//
//  Created by Ostap Holub on 11/13/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

class FeedDateConverter {
    
    // MARK: - Variables & Constants
    
    private var currentCalendar: Calendar
    
    private struct DifferenceConstants {
        static let week: Int = 7
        static let yesterday: Int = 1
        static let today: Int = 0
    }
    
    // MARK: - Initialization
    
    init() {
        currentCalendar = Calendar.current
    }
    
    // MARK: - Public part
    
    func isToday(_ date: Int32) -> Bool {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let components = differenceComponents(from: date)
        if let unwrappedDays = components.day {
            return unwrappedDays == 0
        }
        return false
    }
    
    func eta(from timestamp: Int32) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
    
    func timeAgoInWords(from timestamp: Int32) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return timeAgoInWords(from: date)
    }
    
    func feedDetailsTimeAgo(from timestamp: Int32) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        var finalDateString = timeAgoInWords(from: date)
        if differenceInMonth(from: date) == 0 && differenceInYears(from: date) == 0 {
            if differenceInDay(from: date)! > DifferenceConstants.today && differenceInDay(from: date)! <= DifferenceConstants.week {
                finalDateString += "\n\(fullDateString(from: date))"
            } else {
                finalDateString = timeAgoInWords(from: date)
            }
        }
        
        return finalDateString
    }
    
    func timeAgoInWords(from date: Date) -> String {
        let difference = differenceComponents(from: date)
        guard let dayDifference = difference.day else { return defaultDayFormat(from: date) }
        if difference.year != 0 || difference.month != 0 { return defaultDayFormat(from: date) }
        
        if dayDifference == DifferenceConstants.today {
            return time(from: date)
        } else if dayDifference == DifferenceConstants.yesterday {
            return LocalizedStringKey.FeedDateConverterHelper.Yesterday
        } else if dayDifference <= DifferenceConstants.week {
            return dayName(from: date)
        } else {
            return defaultDayFormat(from: date)
        }
    }
    
    // MARK: - Private part
    
    private func time(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    private func dayName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    private func defaultDayFormat(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YY"
        return formatter.string(from: date)
    }
    
    private func normalizedDate(from date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.date(from: date)!
    }
    
    // MARK: - Difference in days
    
    private func differenceComponents(from date: Date) -> DateComponents {
        let currentDate = Date()
        
        let currentStringDate = defaultDayFormat(from: currentDate)
        let stringDate = defaultDayFormat(from: date)
        
        let convertedCurrentDate = normalizedDate(from: currentStringDate)
        let convertedDate = normalizedDate(from: stringDate)
        
        return currentCalendar.dateComponents([.day, .month, .year], from: convertedDate, to: convertedCurrentDate)
    }
    
    private func differenceInDay(from date: Date) -> Int? {
        let currentDate = Date()
        let components = currentCalendar.dateComponents([.day], from: currentDate, to: date)
        if let unwrappedDay = components.day {
            return abs(unwrappedDay)
        }
        return nil
    }
    
    private func differenceInMonth(from date: Date) -> Int? {
        let currentDate = Date()
        let components = currentCalendar.dateComponents([.month], from: date)
        let currentComponents = currentCalendar.dateComponents([.month], from: currentDate)
        if let currentMonth = currentComponents.month, let month = components.month {
            return currentMonth - month
        }
        return nil
    }
    
    private func differenceInYears(from date: Date) -> Int? {
        let currentDate = Date()
        let components = currentCalendar.dateComponents([.year], from: date)
        let currentComponents = currentCalendar.dateComponents([.year], from: currentDate)
        if let currentYear = currentComponents.year, let year = components.year {
            return currentYear - year
        }
        return nil
    }
    
    private func fullDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY, h:mm a"
        return formatter.string(from: date)
    }
}
