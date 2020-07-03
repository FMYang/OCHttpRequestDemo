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

//- (FMHttpReuqestMethod)method {
//    return FMHttpReuqestMethodPost;
//}
//
//- (NSString *)baseUrl {
//    return @"";
//}
//
//- (NSDictionary *)params {
//    return @{};
//}

//- (NSString *)path {
//    return @"";
//}
//
//- (NSTimeInterval)timeoutInterval {
//    return 0;
//}

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

#pragma mark -
+ (FMRequest * _Nonnull (^)(void))build {
    return ^ {
        return [[self alloc] init];
    };
}

- (FMRequest * _Nonnull (^)(NSString * _Nullable))reqUrl {
    return ^FMRequest *(NSString *url) {
        self.path = url;
        return self;
    };
}

- (FMRequest * _Nonnull (^)(FMHttpReuqestMethod))reqMethod {
    return ^FMRequest *(FMHttpReuqestMethod method) {
        self.method = method;
        return self;
    };
}

- (FMRequest * _Nonnull (^)(NSDictionary * _Nullable))reqParams {
    return ^ (NSDictionary *params){
        self.params = params;
        return self;
    };
}

#pragma mark -
- (NSString *)description {
    return [NSString stringWithFormat:@"url = %@, method = %ld, params = %@", self.baseUrl, self.method, self.params];
}
@end
