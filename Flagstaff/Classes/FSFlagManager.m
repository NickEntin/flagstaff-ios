//
//  FSFlagManager.m
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

#import "FSFlagManager.h"

#import "FSFlag.h"

@interface FSFlagManager ()

@property (nonatomic) NSString *urlFormat;
@property (nonatomic) NSMutableDictionary<NSString *, FSFlag *> *flags;

@end

@implementation FSFlagManager

const NSString *kFlagstaffFlagsUserDefaultsKey = @"flagstaff_flags_key";

const NSString *kFlagKeyJSONKey = @"key";
const NSString *kFlagEnabledJSONKey = @"enabled";
const NSString *kFlagParametersJSONKey = @"parameters";
const NSString *kFlagTTLJSONKey = @"ttl";

- (instancetype)initWithURLFormat:(NSString *)urlFormat
{
    if (self = [super init]) {
        _urlFormat = urlFormat;
        
        // Set fetch timeout to default value of 1 second
        _fetchTimeout = 1.0;
        
        // Set default flag TTL to default value of 30 minutes
        _defaultFlagTTL = 1800.0;
        
        _flags = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kFlagstaffFlagsUserDefaultsKey];
        if (!_flags) {
            _flags = [NSMutableDictionary dictionary];
        }
    }
    return self;
}

#pragma mark - Public Methods

- (BOOL)enableFeatureForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
    FSFlag *flag = [self.flags objectForKey:key];
    
    if (!flag || [self _flagHasExpired:flag]) {
        [self _updateFlagForKey:key synchronous:(flag == nil)];
        flag = [self.flags objectForKey:key];
    }
    
    if (flag) {
        return flag.enabled;
    }
    
    return defaultValue;
}

- (NSDictionary<NSString *,id> *)parametersForKey:(NSString *)key defaultValue:(NSDictionary<NSString *,id> *)defaultValue
{
    FSFlag *flag = [self.flags objectForKey:key];
    
    if (!flag || [self _flagHasExpired:flag]) {
        [self _updateFlagForKey:key synchronous:(flag == nil)];
        flag = [self.flags objectForKey:key];
    }
    
    if (flag) {
        return flag.parameters;
    }
    
    return defaultValue;
}

#pragma mark - Convenience Methods

- (BOOL)enableFeatureForKey:(NSString *)key
{
    return [self enableFeatureForKey:key defaultValue:NO];
}

- (NSDictionary<NSString *,id> *)parametersForKey:(NSString *)key
{
    return [self parametersForKey:key defaultValue:nil];
}

#pragma mark - Update

- (void)updateAllFlags
{
    for (NSString *key in self.flags.keyEnumerator.allObjects) {
        [self _updateFlagForKey:key synchronous:NO];
    }
}

#pragma mark - Utilities (Private)

- (BOOL)_flagHasExpired:(FSFlag *)flag
{
    return [[NSDate date] timeIntervalSinceDate:flag.lastUpdated] >= flag.ttl;
}

#pragma mark - Update (Private)

- (void)_updateFlagForKey:(NSString *)key synchronous:(BOOL)synchronous
{
    dispatch_semaphore_t responseSemaphore = dispatch_semaphore_create(0);
    
    [NSURLConnection sendAsynchronousRequest:[self _urlRequestForKey:key]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               if (!connectionError && data) {
                                   NSError *parseError;
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                   if (!parseError && json) {
                                       FSFlag *flag = [self _flagFromDictionary:json];
                                       if (flag) {
                                           [self.flags setObject:flag forKey:flag.key];
                                       }
                                   }
                               }
                               
                               dispatch_semaphore_signal(responseSemaphore);
                           }];
    
    if (synchronous) {
        dispatch_semaphore_wait(responseSemaphore, dispatch_time(DISPATCH_TIME_NOW, self.fetchTimeout * NSEC_PER_SEC));
    }
}

- (NSURLRequest *)_urlRequestForKey:(NSString *)key
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self _urlForKey:key]]];
    [urlRequest setHTTPMethod:@"GET"];
    return urlRequest;
}

- (NSString *)_urlForKey:(NSString *)key
{
    return [self.urlFormat stringByReplacingOccurrencesOfString:@"{flag}" withString:key];
}

- (FSFlag *)_flagFromDictionary:(NSDictionary *)dictionary
{
    NSString *key = [dictionary objectForKey:kFlagKeyJSONKey];
    NSNumber *enabled = [dictionary objectForKey:kFlagEnabledJSONKey];
    if (key != nil && enabled != nil) {
        FSFlag *flag = [self.flags objectForKey:key];
        if (!flag) {
            flag = [[FSFlag alloc] init];
        }
        
        flag.key = key;
        flag.enabled = [enabled boolValue];
        flag.parameters = [dictionary objectForKey:kFlagParametersJSONKey];
        
        NSNumber *ttl = [dictionary objectForKey:kFlagTTLJSONKey];
        flag.ttl = ttl ? [ttl doubleValue] : self.defaultFlagTTL;
        
        flag.lastUpdated = [NSDate date];
        
        return flag;
    }
    return nil;
}

@end
