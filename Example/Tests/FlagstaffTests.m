//
//  FlagstaffTests.m
//  Flagstaff
//
//  Copyright (c) 2016 Nick Entin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <XCTest/XCTestCase.h>

#import <Flagstaff/FSFlagManager.h>

@interface Tests : XCTestCase

@property (nonatomic) FSFlagManager *flagManager;

@end

@implementation Tests

- (void)setUp
{
    [super setUp];

    NSString *urlFormat = [NSString stringWithFormat:@"file://%@", [[[NSBundle mainBundle] pathForResource:@"enabled" ofType:@"json"] stringByReplacingOccurrencesOfString:@"enabled" withString:@"{flag}"]];
    _flagManager = [[FSFlagManager alloc] initWithURLFormat:urlFormat];
}

- (void)testEnabledFlag
{
    XCTAssertEqual([self.flagManager enableFeatureForKey:@"enabled"], YES);
    XCTAssertEqual([self.flagManager parametersForKey:@"enabled"], nil);
}

- (void)testDisabledFlag
{
    XCTAssertEqual([self.flagManager enableFeatureForKey:@"disabled"], NO);
    XCTAssertEqual([self.flagManager parametersForKey:@"disabled"], nil);
}

- (void)testParameteredFlag
{
    NSDictionary *parameters = [self.flagManager parametersForKey:@"parametered"];
    
    XCTAssertNotNil(parameters);
    XCTAssert([[parameters objectForKey:@"number"] isKindOfClass:[NSNumber class]]);
    XCTAssert([[parameters objectForKey:@"number"] isEqualToNumber:@(20)]);
    XCTAssert([[parameters objectForKey:@"string"] isKindOfClass:[NSString class]]);
    XCTAssert([[parameters objectForKey:@"string"] isEqualToString:@"Test string"]);
    XCTAssert([[parameters objectForKey:@"bool"] isKindOfClass:[NSNumber class]]);
    XCTAssert([[parameters objectForKey:@"bool"] isEqualToNumber:@(YES)]);
}

- (void)testMissingFlag
{
    XCTAssertEqual([self.flagManager enableFeatureForKey:@"missing"], NO);
    XCTAssertEqual([self.flagManager enableFeatureForKey:@"missing" defaultValue:YES], YES);
    XCTAssertEqual([self.flagManager parametersForKey:@"missing"], nil);
    
    NSDictionary *defaultParams = @{};
    XCTAssertEqual([self.flagManager parametersForKey:@"missing" defaultValue:defaultParams], defaultParams);
}

@end
