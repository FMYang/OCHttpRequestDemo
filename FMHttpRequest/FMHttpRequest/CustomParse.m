//
//  CustomParse.m
//  FMHttpRequest
//
//  Created by fm y on 2019/12/2.
//  Copyright © 2019 fm y. All rights reserved.
//

#import "CustomParse.h"
#import "YYModel.h"

@implementation CustomParse

- (id)mapJSON:(id)keyValues cls:(Class)cls {
    if([keyValues isKindOfClass:[NSDictionary class]]) {
        return [cls yy_modelWithJSON:keyValues];
    } else if([keyValues isKindOfClass:[NSArray class]]) {
        return [NSArray yy_modelWithJSON:keyValues];
    } else {
        return keyValues;
    }
}

@end
