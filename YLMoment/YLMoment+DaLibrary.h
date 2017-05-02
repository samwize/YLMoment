//
//  YLMoment+DaLibrary.h
//  YLMomentTests
//
//  Created by Junda on 3/5/17.
//  Copyright © 2017 YannickLoriot. All rights reserved.
//

#import "YLMomentObject.h"

#pragma mark Additional classes added by Junda <junda@just2us.com>

@interface YLMoment (DaLibrary)

/**
 * @abstract Returns the friendly version of the date part (without time).
 * @return The friendly version string
 * @discussion
 * Breakdown:
 *
 * Range                            | Sample Output
 * -------------------------------- | -------------
 * Midnight - now                   | Today
 * Yesterday midnight - midnight    | Yesterday
 * 1 day later                      | Tomorrow
 * 7 days ago - Yesterday midnight  | Wednesday
 * 1 year ago - 7 days ago          | 21 Mar
 * Beyond 1 year                    | 21 Mar 2013
 */
- (NSString*)friendlyDay;

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
- (NSString*)friendlyTimePeriod;

// Returns the number of days from today
// eg 0 is today, 1 is tomorrow, -1 is yesterday
- (int)daysFromToday;

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
- (NSString *)friendlyStringV1FromDate:(NSDate *)date withSuffix:(BOOL)suffixed;

/** shortcut to friendlyStringV1FromDate:withSuffix: */
- (NSString *)friendlyStringV1FromTodayWithSuffix:(BOOL)suffixed;
- (NSString *)friendlyStringV1FromToday;

#pragma mark - Helpers

- (NSBundle*)langBundle;

@end
