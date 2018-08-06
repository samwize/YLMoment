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
    
    public func ageFromNow(withDelimiter delimiter: String? = nil) -> String {
        return ageFromDate(Date(), withDelimiter: delimiter)
    }

    /// Return the age, as a pretty string, between date and this moment
    /// eg. 32 years 1 month 3 days
    /// It will omit any units if it is zero eg. will not show 0 day
    /// It does not check if the date is before or after this moment, and take absolute age. It's your responsibility
    /// to check before or after.
    /// - Parameter maxComponents: Default is show all 3 components (year, month and day)
    public func ageFromDate(_ date: Date, withDelimiter delimiter: String? = nil, withMaxComponents maxComponents: Int = 3) -> String {
        var maxComponents = maxComponents
        
        let langBundle = self.localBundle()!
        
        let calendar = Calendar.current
        let c = Set<Calendar.Component>(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day)
        let components = calendar.dateComponents(c, from: self.date(), to: date)

        let years = components.year ?? 0
        let months = components.month ?? 0
        let days = components.day ?? 0
        
        // Form up the age string
        var age = ""
        
        if years != 0 {
            var formattedString = langBundle.localizedString(forKey: "yy", value: "%d years", table: "YLMomentRelativeTimeLocalizable")
            if years == 1 {
                formattedString = langBundle.localizedString(forKey: "y1", value: "%d year", table: "YLMomentRelativeTimeLocalizable")
            }
            if maxComponents > 0 {
                age = NSString(format: formattedString as NSString, years) as String
                age += (delimiter != nil) ? (delimiter! as String + " ") : " "
                maxComponents -= 1
            }
        }
        
        if months != 0 {
            var formattedString = langBundle.localizedString(forKey: "MM", value: "%d months", table: "YLMomentRelativeTimeLocalizable")
            if months == 1 {
                formattedString = langBundle.localizedString(forKey: "M1", value: "%d month", table: "YLMomentRelativeTimeLocalizable")
            }
            if maxComponents > 0 {
                age += NSString(format: formattedString as NSString, months) as String
                age += (delimiter != nil) ? (delimiter! as String + " ") : " "
                maxComponents -= 1
            }
        }
        
        if age.characters.count == 0 || days != 0 {
            var formattedString = langBundle.localizedString(forKey: "dd", value: "%d days", table: "YLMomentRelativeTimeLocalizable")
            if days <= 1 {
                formattedString = langBundle.localizedString(forKey: "d1", value: "%d day", table: "YLMomentRelativeTimeLocalizable")
            }
            if maxComponents > 0 {
                age += NSString(format: formattedString as NSString, days) as String
            }
        }
        
        var trimmingCharacters = " "
        if let delimiter = delimiter {
            trimmingCharacters += delimiter
        }
        return age.trimmingCharacters(in: CharacterSet(charactersIn: trimmingCharacters))
    }
    
}
