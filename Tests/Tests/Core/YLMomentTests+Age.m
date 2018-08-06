//
//  YLMomentTests+Age.m
//  YLMomentTests
//
//  Created by Junda on 5/10/15.
//  Copyright © 2015 YannickLoriot. All rights reserved.
//

#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import "Expecta.h"

#import "YLMoment.h"
#import "iOSTests-Swift.h"
#import "iOSTests-Bridging-Header.h"

@interface YLMomentTests_Age : XCTestCase

@end

@implementation YLMomentTests_Age

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAgeWithinOneMonth {
    YLMoment *dob;
    
    dob = [[YLMoment now] subtractAmountOfTime:0 forCalendarUnit:NSCalendarUnitDay];
    expect([dob ageFromNow]).equal(@"0 day");

    dob = [[YLMoment now] subtractAmountOfTime:1 forCalendarUnit:NSCalendarUnitDay];
    expect([dob ageFromNow]).equal(@"1 day");

    dob = [[YLMoment now] subtractAmountOfTime:15 forCalendarUnit:NSCalendarUnitDay];
    expect([dob ageFromNow]).equal(@"15 days");
    
    // Negative/EDD, just show the absolute
    dob = [[YLMoment now] subtractAmountOfTime:-10 forCalendarUnit:NSCalendarUnitDay];
    expect([dob ageFromNow]).equal(@"10 days");
}

- (void)testAgeWithinOneYear {
    YLMoment *dob;
    
    dob = [[YLMoment now] subtractAmountOfTime:1 forCalendarUnit:NSCalendarUnitMonth];
    expect([dob ageFromNow]).equal(@"1 month");
    dob = [dob subtractAmountOfTime:1 forCalendarUnit:NSCalendarUnitDay];
    expect([dob ageFromNow]).equal(@"1 month 1 day");

    dob = [[YLMoment now] subtractAmountOfTime:2 forCalendarUnit:NSCalendarUnitMonth];
    expect([dob ageFromNow]).equal(@"2 months");
    dob = [dob subtractAmountOfTime:3 forCalendarUnit:NSCalendarUnitDay];
    expect([dob ageFromNow]).equal(@"2 months 3 days");

    dob = [[YLMoment now] subtractAmountOfTime:11 forCalendarUnit:NSCalendarUnitMonth];
    expect([dob ageFromNow]).equal(@"11 months");

    dob = [[YLMoment now] subtractAmountOfTime:12 forCalendarUnit:NSCalendarUnitMonth];
    expect([dob ageFromNow]).equal(@"1 year");
}

- (void)testAgeMoreThanOneYear {
    YLMoment *dob;
    
    dob = [[YLMoment now] subtractAmountOfTime:1 forCalendarUnit:NSCalendarUnitYear];
    expect([dob ageFromNow]).equal(@"1 year");
    dob = [dob subtractAmountOfTime:1 forCalendarUnit:NSCalendarUnitMonth];
    expect([dob ageFromNow]).equal(@"1 year 1 month");
    dob = [dob subtractAmountOfTime:1 forCalendarUnit:NSCalendarUnitDay];
    expect([dob ageFromNow]).equal(@"1 year 1 month 1 day");
    
    dob = [[YLMoment now] subtractAmountOfTime:10 forCalendarUnit:NSCalendarUnitYear];
    expect([dob ageFromNow]).equal(@"10 years");
    dob = [dob subtractAmountOfTime:10 forCalendarUnit:NSCalendarUnitMonth];
    expect([dob ageFromNow]).equal(@"10 years 10 months");
    dob = [dob subtractAmountOfTime:10 forCalendarUnit:NSCalendarUnitDay];
    expect([dob ageFromNow]).equal(@"10 years 10 months 10 days");
}

- (void)testAgeWithDelmiter {
    YLMoment *dob;
    
    dob = [[YLMoment now] subtractAmountOfTime:1 forCalendarUnit:NSCalendarUnitYear];
    expect([dob ageFromNowWithDelimiter:@","]).equal(@"1 year");
    dob = [dob subtractAmountOfTime:1 forCalendarUnit:NSCalendarUnitMonth];
    expect([dob ageFromNowWithDelimiter:@","]).equal(@"1 year, 1 month");
    dob = [dob subtractAmountOfTime:1 forCalendarUnit:NSCalendarUnitDay];
    expect([dob ageFromNowWithDelimiter:@","]).equal(@"1 year, 1 month, 1 day");
}

@end
