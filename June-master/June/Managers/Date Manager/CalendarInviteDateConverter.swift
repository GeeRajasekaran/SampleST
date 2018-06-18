//
//  CalendarInviteDateConverter.swift
//  June
//
//  Created by Ostap Holub on 11/22/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation
import SwiftyJSON

class CalendarInviteDateConveter {
    
    // MARK: - Variables
    
    private var currentCalendar: Calendar
    private let kStartDate: String = "start_date"
    private let kStartTime: String = "start_time"
    private let kEndTime: String = "end_time"
    
    private var outputDateFormatter: DateFormatter
    
    // MARK: - Initialization
    
    init() {
        currentCalendar = Calendar.current
        outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "EEE MMM d, YYYY"
    }
    
    // MARK: - Public methods
    
    func eventTime(from jsonString: String?) -> String? {
        guard let unwrappedJsonString = jsonString else { return nil }
        let json = JSON(parseJSON: unwrappedJsonString)
        var finalTime: String?
    
        if isAllDayEvent(json) {
            finalTime = allDayTime(from: json)
        } else {
            finalTime = regularTime(from: json)
        }
        return finalTime
    }
    
    // MARK: - Private methods
    
    private func isAllDayEvent(_ json: JSON) -> Bool {
        if json[kStartDate].string != nil {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Conversion logic
    
    private func allDayTime(from json: JSON) -> String? {
        if let dateString = json[kStartDate].string, let dayDate = date(from: dateString) {
            var finalDateString = outputDateFormatter.string(from: dayDate)
            finalDateString += LocalizedStringKey.FeedCalendarInvite.AllDayTitle
            return finalDateString
        }
        return nil
    }
    
    private func regularTime(from json: JSON) -> String? {
        if let startTS = json[kStartTime].int32, let endTS = json[kEndTime].int32 {
            if let startDate = date(from: startTS), let endDate = date(from: endTS) {
                var finalDateString = outputDateFormatter.string(from: startDate)
                if let startHours = hoursString(from: startDate), let endHours = hoursString(from: endDate) {
                    finalDateString += " \(startHours) - \(endHours)"
                }
                return finalDateString
            }
        }
        return nil
    }
    
    // MARK: - Date formatting
    
    private func date(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.date(from: string)
    }
    
    private func date(from timestamp: Int32) -> Date? {
        let interval = Double(timestamp)
        return Date(timeIntervalSince1970: interval)
    }
    
    private func containsMinutes(_ date: Date) -> Bool {
        let minutes = Calendar.current.component(.minute, from: date)
        return minutes != 0
    }
    
     private func hoursString(from date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = containsMinutes(date) ? "h:mma" : "ha"
        formatter.amSymbol = LocalizedStringKey.FeedCalendarInvite.AmTitle
        formatter.pmSymbol = LocalizedStringKey.FeedCalendarInvite.PmTitle
        return formatter.string(from: date)
    }
}
