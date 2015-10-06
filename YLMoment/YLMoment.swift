//
//  YLMoment.swift
//  YLMomentTests
//
//  Created by Junda on 6/10/15.
//  Copyright © 2015 YannickLoriot. All rights reserved.
//

import Foundation

extension YLMoment {
    
    public func ageFromNow() -> String {
        return self.ageFromNow(withDelimiter: nil)
    }

    // Return the age as of now as a pretty string
    // eg. 32 years 1 month 3 days
    // It will omit if any value is zero
    public func ageFromNow(withDelimiter delimiter: String? = nil) -> String {
        let langBundle = self.langBundle()
        
        let calendar = NSCalendar.currentCalendar()
        
        // Ensure date of components1 < components2
        // Supposed if age is negative, the method will assume an absolute value
        var components1, components2: NSDateComponents
        let today = NSDate()
        if (self.date().timeIntervalSinceDate(today) < 0) {
            components1 = calendar.components([.Year, .Month, .Day], fromDate: self.date())
            components2 = calendar.components([.Year, .Month, .Day], fromDate: today)
        } else {
            components2 = calendar.components([.Year, .Month, .Day], fromDate: self.date())
            components1 = calendar.components([.Year, .Month, .Day], fromDate: today)
        }

        var years = components2.year - components1.year
        
        var months = components2.month - components1.month
        if months < 0 {
            months += 12
            years -= 1
        }
        
        var days = components2.day - components1.day
        if days < 0 {
            // Number of days last month
            let componentsLastMonth = components2
            if componentsLastMonth.month == 0 {
                componentsLastMonth.month = 12
                componentsLastMonth.year -= 1
            } else {
                componentsLastMonth.month -= 1
            }
            let lastMonthDate = calendar.dateFromComponents(componentsLastMonth)
            let daysInMonth = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: lastMonthDate!)
            
            days += daysInMonth.length
            months -= 1
        }

        // Absolute values
        years = abs(years)
        months = abs(months)
        days = abs(days)
        
        // Form up the age string
        var age = ""
        
        if years != 0 {
            var formattedString = langBundle.localizedStringForKey("yy", value: "%d years", table: "YLMomentRelativeTimeLocalizable")
            if years == 1 {
                formattedString = langBundle.localizedStringForKey("y1", value: "%d year", table: "YLMomentRelativeTimeLocalizable")
            }
            age = NSString(format: formattedString, years) as String
            age += (delimiter != nil) ? (delimiter! as String + " ") : " "
        }
        
        if months != 0 {
            var formattedString = langBundle.localizedStringForKey("MM", value: "%d months", table: "YLMomentRelativeTimeLocalizable")
            if months == 1 {
                formattedString = langBundle.localizedStringForKey("M1", value: "%d month", table: "YLMomentRelativeTimeLocalizable")
            }
            age += NSString(format: formattedString, months) as String
            age += (delimiter != nil) ? (delimiter! as String + " ") : " "
        }
        
        if age.characters.count == 0 || days != 0 {
            var formattedString = langBundle.localizedStringForKey("dd", value: "%d days", table: "YLMomentRelativeTimeLocalizable")
            if days <= 1 {
                formattedString = langBundle.localizedStringForKey("d1", value: "%d day", table: "YLMomentRelativeTimeLocalizable")
            }
            age += NSString(format: formattedString, days) as String
        }
        
        var trimmingCharacters = " "
        if let delimiter = delimiter {
            trimmingCharacters += delimiter
        }
        return age.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: trimmingCharacters))
    }
    
}
