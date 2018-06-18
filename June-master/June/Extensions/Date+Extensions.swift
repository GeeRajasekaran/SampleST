//
//  Date+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

extension Date {
    
    var dayName: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: self)
        }
    }
    
    func midnight() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: self)
    }
    
    static func loadDate(from date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: date)
    }
    
    func dayOfWeek() -> Int? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return weekDay
    }
    
    func dayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.date(from: today) {
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: todayDate)
            return weekDay
        } else {
            return nil
        }
    }
    
    static func nextDay(date: Date) -> Date? {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)
        return tomorrow
    }
    
    static func monthName(_ month: Int) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        
        let months = dateFormatter.shortMonthSymbols
        if let monthSymbol = months?[month-1] {
            return monthSymbol
        }
        return ""
    }
    
    func isGreaterThanDate(dateToCompare : Date) -> Bool
    {
        var isGreater = false
        
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        return isGreater
    }

    // MARK: - Time ago in words
    
    static func timeInWords(from timestamp: Int32) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return DateConverter().timeInWords(from: date)
    }
    
    static func dateAndTimeFormat(from timestamp: Int32) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: date)
    }
    
    static func timeFormat(from timestamp: Int32) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    static func timeFormatWithPartOfDay(from timestamp: Int32) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mmaa"
        return formatter.string(from: date)
    }
    
    // MARK: - Timestamp logic
    
    static var timestampOfNow: Int {
        get { return Int(Date().timeIntervalSince1970) }
    }
    
}
