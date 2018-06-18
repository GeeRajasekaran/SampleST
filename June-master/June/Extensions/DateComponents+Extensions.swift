//
//  DateComponents+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

extension DateComponents {
    
    static func loadCurrentComponent() -> DateComponents {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second,
            .weekday
        ]
        
        return userCalendar.dateComponents(requestedComponents, from: currentDateTime)
    }
    
    static func loadComponent(from date: Date) -> DateComponents {
        let userCalendar = Calendar.current
        
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second,
            .weekday
            
        ]
        
        return userCalendar.dateComponents(requestedComponents, from: date)
    }
}
