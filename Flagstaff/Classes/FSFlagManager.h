//
//  FSFlagManager.h
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

@interface FSFlagManager : NSObject

/**
 *  Designated initializer, takes as argument the URL format to use, i.e.:
 *
 *      https://example.com/flags/{flag}.json
 */
- (instancetype)initWithURLFormat:(NSString *)urlFormat;

/**
 *  Returns whether or not the given feature should be enabled. If unable to fetch the flag, the default value will be returned.
 */
- (BOOL)enableFeatureForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

/**
 *  Convenience method with default value of NO.
 */
- (BOOL)enableFeatureForKey:(NSString *)key;

/**
 *  Returns an optional dictionary of parameters associated with the flag.
 */
- (NSDictionary<NSString *, id> *_Nullable)parametersForKey:(NSString *)key defaultValue:(NSDictionary<NSString *, id> *_Nullable)defaultValue;

/**
 *  Convenience method with default value of nil.
 */
- (NSDictionary<NSString *, id> *_Nullable)parametersForKey:(NSString *)key;

/**
 *  Fetch updates for all existing flags.
 */
- (void)updateAllFlags;

/**
 *  Timeout for initial flag fetch attempts (defaults to 1 second).
 */
@property (nonatomic) NSTimeInterval fetchTimeout;

/**
 *  Default TTL applied to flags for which the TTL is not explicitly defined (defaults to 30 minutes).
 */
@property (nonatomic) NSTimeInterval defaultFlagTTL;

@end

NS_ASSUME_NONNULL_END
