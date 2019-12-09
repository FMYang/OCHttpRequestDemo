//
//  FMRequest.m
//  FMHttpRequest
//
//  Created by fm y on 2019/11/29.
//  Copyright © 2019 fm y. All rights reserved.
//

#import "FMRequest.h"

#define FMMethodNotImplemented() \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil]; \

@implementation FMRequest

- (FMHttpReuqestMethod)method {
    return FMHttpReuqestMethodPost;
}

- (NSString *)baseUrl {
    return @"";
}

- (NSDictionary *)params {
    return @{};
}

- (NSString *)path {
    return @"";
}

- (NSTimeInterval)timeoutInterval {
    return 0;
}

#pragma mark -
- (NSString *)requestMethod {
    switch (self.method) {
        case FMHttpReuqestMethodGet:
            return @"GET";
            break;
            
        case FMHttpReuqestMethodPost:
            return @"POST";
            break;
            
        case FMHttpReuqestMethodPut:
            return @"PUT";
            break;
            
        case FMHttpReuqestMethodDelete:
            return @"DELETE";
            break;
            
        default:
            break;
    }
}

@end
