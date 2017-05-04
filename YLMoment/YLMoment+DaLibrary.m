//
//  YLMoment+DaLibrary.m
//  YLMomentTests
//
//  Created by Junda on 3/5/17.
//  Copyright © 2017 YannickLoriot. All rights reserved.
//

#import "YLMoment+DaLibrary.h"
#import "YLMoment+Description.h"

static NSString * const kYLMomentRelativeTimeStringTable99 = @"YLMomentRelativeTimeLocalizable";

#pragma mark Additional classes added by Junda <junda@just2us.com>

@implementation YLMoment (DaLibrary)

- (NSString*)friendlyDay {
    // Get the lang bundle
    NSBundle *langBundle = self.langBundle ?: [[[self class] proxy] langBundle] ?: [NSBundle mainBundle];
    
    NSInteger diffInDays = -[self daysFromToday];
    
    if (diffInDays < -1) {
        // Future
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"dMMMyyyy" options:0 locale:[NSLocale currentLocale]];
        return [self format:dateFormat];
    } else if (diffInDays == -1) {
        return [langBundle localizedStringForKey:@"Tomorrow" value:@"" table:kYLMomentRelativeTimeStringTable99];
    } else if (diffInDays == 0) {
        // TODO: localize Today and Yesterday in strings file
        return [langBundle localizedStringForKey:@"Today" value:@"" table:kYLMomentRelativeTimeStringTable99];
    } else if (diffInDays == 1) {
        return [langBundle localizedStringForKey:@"Yesterday" value:@"" table:kYLMomentRelativeTimeStringTable99];
    } else if (diffInDays < 7) {
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEE" options:0 locale:[NSLocale currentLocale]];
        return [self format:dateFormat];
    } else if (diffInDays < 360) {  // Approximately 1 year
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"dMMM" options:0 locale:[NSLocale currentLocale]];
        return [self format:dateFormat];
    } else {
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"dMMMyyyy" options:0 locale:[NSLocale currentLocale]];
        return [self format:dateFormat];
    }
}

/**
 * @abstract Returns the friendly version of the time part (without date).
 * @return The friendly version string
 * @discussion Breakdown:
 * Range                        | Sample Output
 * ---------------------------- | -------------
 * 6am - 12pm (6hr)             | Morning
 * 12pm - 6pm (6hr)             | Afternoon
 * 6pm - 12mn (6hr)             | Night
 * 12mn - 6am (6hr)             | Wee Hours
 */
- (NSString*)friendlyTimePeriod {
    // Get the lang bundle
    NSBundle *langBundle = self.langBundle ?: [[[self class] proxy] langBundle] ?: [NSBundle mainBundle];
    
    // Calculate the diff in days
    NSCalendar *currentCalendar  = self.calendar ?: [[[self class] proxy] calendar];
    NSDateComponents *dateComponents = [currentCalendar components:(NSHourCalendarUnit) fromDate: self.date];
    
    NSInteger hour = [dateComponents hour];
    
    if (hour < 6) {
        return [langBundle localizedStringForKey:@"Wee Hours" value:@"" table:kYLMomentRelativeTimeStringTable99];
    } else if (hour < 12) {
        return [langBundle localizedStringForKey:@"Morning" value:@"" table:kYLMomentRelativeTimeStringTable99];
    } else if (hour < 18) {
        return [langBundle localizedStringForKey:@"Afternoon" value:@"" table:kYLMomentRelativeTimeStringTable99];
    } else {
        return [langBundle localizedStringForKey:@"Night" value:@"" table:kYLMomentRelativeTimeStringTable99];
    }
}

- (int)daysFromToday {
    NSCalendar *currentCalendar  = self.calendar ?: [[[self class] proxy] calendar];
    NSDate *today = [NSDate date];
    
    NSDate *fromDate;
    NSDate *toDate;
    [currentCalendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:NULL forDate:today];
    [currentCalendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate: self.date];
    NSDateComponents *difference = [currentCalendar components:NSDayCalendarUnit
                                                      fromDate:fromDate toDate:toDate options:0];
    
    NSInteger diffInDays = [difference day];
    return (int)diffInDays;
}

/** A version of fromDate:withSuffix: known as V1 (for a lack of a better name)
 *
 * The range was modified to suit a common range of less than 7 days.
 *
 * Used by: Poo Keeper
 *
 * For 25 to 7*24 hours, the format is "d1/dd h1/hh", which is concatenating the days and hours
 * components. The order might not be correctly represented in a localized language.
 *
 * d1 and h1 was introduced too to mean "1 day" instead of "a day"
 *
 * Range                       | Key | Sample Output
 * --------------------------- | --- | -------------
 * 0 to 45 seconds             | s   | a few seconds ago
 * 45 to 90 seconds            | m1  | 1 minute ago
 * 90 seconds to 45 minutes    | mm  | 2 minutes ago ... 45 minutes ago
 * 45 to 90 minutes            | h1  | 1 hour ago
 * 90 minutes to 23 hours      | hh  | 2 hours ago ... 23 hours ago
 * 23 to 25 hours              | d1  | 1 day ago
 * 25 hours to 7*24 hours      | d1/dd h1/hh  | 1 day 1 hour ago ... 7 days 23 hours ago
 * 8 days to any               | dd  | 8 days ago ... 999 days ago
 */
- (NSString *)friendlyStringV1FromDate:(NSDate *)date withSuffix:(BOOL)suffixed {
    // Get the lang bundle
    NSBundle *langBundle = self.langBundle ?: [[[self class] proxy] langBundle] ?: [NSBundle mainBundle];
    
    // Compute the time interval
    double referenceTime = [self.date timeIntervalSinceDate:date];
    double seconds       = round(fabs(referenceTime));
    double minutes       = round(seconds / 60.0f);
    double hours         = round(minutes / 60.0f);
    double days          = round(hours / 24.0f);
    
    // Build the formatted string
    NSString *formattedString = @"";
    int unit                  = 0;
    if (seconds < 45)
    {
        formattedString = [langBundle localizedStringForKey:@"s" value:@"a few seconds" table:kYLMomentRelativeTimeStringTable99];
        unit            = seconds;
    } else if (minutes == 1)
    {
        formattedString = [langBundle localizedStringForKey:@"m1" value:@"%d minute" table:kYLMomentRelativeTimeStringTable99];
        unit            = minutes;
    } else if (minutes < 45)
    {
        formattedString = [langBundle localizedStringForKey:@"mm" value:@"%d minutes" table:kYLMomentRelativeTimeStringTable99];
        unit            = minutes;
    } else if (minutes < 90)
    {
        formattedString = [langBundle localizedStringForKey:@"h1" value:@"%d hour" table:kYLMomentRelativeTimeStringTable99];
        unit            = hours;
    } else if (hours < 24)
    {
        formattedString = [langBundle localizedStringForKey:@"hh" value:@"%d hours" table:kYLMomentRelativeTimeStringTable99];
        unit            = hours;
    } else if (hours == 24)
    {
        formattedString = [langBundle localizedStringForKey:@"d1" value:@"%d day" table:kYLMomentRelativeTimeStringTable99];
        unit            = days;
    } else if (days <= 7)
    {
        // Format "d1/dd h1/hh"
        int day_part = floor(hours/24);
        int hours_part = (int)hours % 24;
        
        NSString *formattedDay = [langBundle localizedStringForKey:@"dd" value:@"%d days" table:kYLMomentRelativeTimeStringTable99];
        if (day_part == 1)
            formattedDay = [langBundle localizedStringForKey:@"d1" value:@"%d day" table:kYLMomentRelativeTimeStringTable99];
        
        NSString *formattedHours = [langBundle localizedStringForKey:@"hh" value:@"%d hours" table:kYLMomentRelativeTimeStringTable99];
        if (hours_part == 0)
            formattedHours = nil;
        else if (hours_part == 1)
            formattedHours = [langBundle localizedStringForKey:@"h1" value:@"%d hour" table:kYLMomentRelativeTimeStringTable99];
        
        // Resolve hours part
        if (formattedHours)
            formattedHours = [NSString stringWithFormat:formattedHours, hours_part];
        
        // Concat
        if (formattedHours == nil)
            formattedString = formattedDay;
        else
            formattedString = [formattedDay stringByAppendingFormat:@" %@", formattedHours];
        unit = day_part;
    } else
    {
        formattedString = [langBundle localizedStringForKey:@"dd" value:@"%d days" table:kYLMomentRelativeTimeStringTable99];
        unit            = days;
    }
    formattedString = [NSString stringWithFormat:formattedString, unit];
    
    // If the string needs to be suffixed
    if (suffixed)
    {
        BOOL isFuture = (referenceTime > 0);
        
        NSString *suffixedString = nil;
        if (isFuture)
        {
            suffixedString = [langBundle localizedStringForKey:@"future" value:@"in %@" table:kYLMomentRelativeTimeStringTable99];
        } else
        {
            suffixedString = [langBundle localizedStringForKey:@"past" value:@"%@ ago" table:kYLMomentRelativeTimeStringTable99];
        }
        
        formattedString = [NSString stringWithFormat:suffixedString, formattedString];
    }
    
    return formattedString;
}

- (NSString *)friendlyStringV1FromTodayWithSuffix:(BOOL)suffixed {
    return [self friendlyStringV1FromDate:[NSDate date] withSuffix:suffixed];
}

- (NSString *)friendlyStringV1FromToday {
    return [self friendlyStringV1FromTodayWithSuffix:YES];
}

#pragma mark - Helpers

// Expose this to Swift
- (NSBundle*)langBundle {
    return self.langBundle ?: [[[self class] proxy] langBundle] ?: [NSBundle mainBundle];
}

@end
