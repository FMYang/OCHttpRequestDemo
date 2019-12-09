//
//  CustomRequest.m
//  FMHttpRequest
//
//  Created by fmy on 2019/12/6.
//  Copyright © 2019 fm y. All rights reserved.
//

#import "CustomRequest.h"
#import "VideoModel.h"

@implementation CustomRequest

- (instancetype)initWithPage:(int)page
                       count:(int)count
                        type:(NSString *)type {
    if (self = [super init]) {
        self.page = page;
        self.count = count;
        self.type = type;
    }
    return self;
}

- (NSString *)path {
    return @"/getJoke";
}

- (NSDictionary *)params {
    return @{@"page": @(_page),
             @"count": @(_count),
             @"type": _type};
}

- (Class)responseClass {
    return [VideoModel class];
}

@end
