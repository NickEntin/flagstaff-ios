//
//  FSFlag.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSFlag : NSObject

/**
 *  The key used to access this flag. This must be a unique identifier across all flags.
 */
@property (nonatomic) NSString *key;

/**
 *  Whether or not the feature associated with this flag should be enabled.
 */
@property (nonatomic) BOOL enabled;

/**
 *  Optional dictionary of parameters associated with this flag.
 */
@property (nonatomic, nullable) NSDictionary<NSString *, id> *parameters;

/**
 *  Date the flag was last updated from the server.
 */
@property (nonatomic, nullable) NSDate *lastUpdated;

/**
 *  Time until the flag should be updated.
 */
@property (nonatomic) NSTimeInterval ttl;

@end

NS_ASSUME_NONNULL_END
