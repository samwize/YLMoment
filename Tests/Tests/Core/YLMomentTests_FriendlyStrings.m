//
//  YLMomentTests_FriendlyStrings.m
//  YLMomentTests
//
//  Created by Junda on 27/1/15.
//  Copyright (c) 2015 YannickLoriot. All rights reserved.
//

#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import "Expecta.h"

#import "YLMoment_UnitTestAdditions.h"

#import "YLMoment.h"

@interface YLMomentTests_FriendlyStrings : XCTestCase
@property(nonatomic, strong) YLMoment *now;
@property(nonatomic, strong) NSDate *dateNow;
@end

@implementation YLMomentTests_FriendlyStrings

- (void)setUp
{
    [super setUp];
    
    [[YLMoment proxy] setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    
    self.now = [[YLMoment alloc] initWithDateAsString:@"2015-01-27" format:@"yyyy-MM-dd"];
    // Must set locale this way!
    self.now.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    self.dateNow = [self.now date];
}

- (void)tearDown
{
    [[YLMoment proxy] setLocale:[NSLocale currentLocale]];
    self.now = nil;
    
    [super tearDown];
}

- (void)testSeconds
{
    [_now subtractAmountOfTime:1 forUnitKey:@"s"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"a few seconds ago");

    _now = [_now subtractAmountOfTime:43 forUnitKey:@"s"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"a few seconds ago");
}

- (void)testMinutesAgo {
    [_now subtractAmountOfTime:45 forUnitKey:@"s"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"1 minute ago");

    [_now subtractAmountOfTime:44 forUnitKey:@"s"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"1 minute ago");

    [_now subtractAmountOfTime:1 forUnitKey:@"s"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"2 minutes ago");

    [_now subtractAmountOfTime:42 forUnitKey:@"m"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"44 minutes ago");
}

- (void)test1Hour
{
    [_now subtractAmountOfTime:45 forUnitKey:@"m"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"1 hour ago");
    
    _now = [_now subtractAmountOfTime:44 forUnitKey:@"m"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"1 hour ago");
}

- (void)testHours
{
    [_now subtractAmountOfTime:90 forUnitKey:@"m"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"2 hours ago");
    
    _now = [_now subtractAmountOfTime:30 forUnitKey:@"m"];
    _now = [_now subtractAmountOfTime:21 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"23 hours ago");
}

- (void)test1Day
{
    [_now subtractAmountOfTime:24 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"1 day ago");
    
    _now = [_now subtractAmountOfTime:29 forUnitKey:@"m"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"1 day ago");
}

- (void)testDaysHours
{
    [_now subtractAmountOfTime:25 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"1 day 1 hour ago");
    
    _now = [_now subtractAmountOfTime:23 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"2 days ago");

    _now = [_now subtractAmountOfTime:1 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"2 days 1 hour ago");

    _now = [_now subtractAmountOfTime:1 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"2 days 2 hours ago");

    _now = [_now subtractAmountOfTime:5 forUnitKey:@"d"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"7 days 2 hours ago");

    _now = [_now subtractAmountOfTime:1 forUnitKey:@"d"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"8 days ago");
}


- (void)testProgressiveHourly
{
    [_now subtractAmountOfTime:1 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"1 hour ago");

    [_now subtractAmountOfTime:1 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"2 hours ago");

    [_now subtractAmountOfTime:2 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"4 hours ago");

    [_now subtractAmountOfTime:8 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"12 hours ago");

    [_now subtractAmountOfTime:6 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"18 hours ago");

    [_now subtractAmountOfTime:6 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"1 day ago");

    [_now subtractAmountOfTime:4 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"1 day 4 hours ago");

    [_now subtractAmountOfTime:8 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"1 day 12 hours ago");

    [_now subtractAmountOfTime:4 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"1 day 16 hours ago");

    [_now subtractAmountOfTime:8 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"2 days ago");

    [_now subtractAmountOfTime:6 forUnitKey:@"h"];
    expect([_now friendlyStringV1FromDate:_dateNow withSuffix:YES]).to.equal(@"2 days 6 hours ago");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
