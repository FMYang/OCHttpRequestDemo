//
//  FMLoadingPlugin.m
//  FMHttpRequest
//
//  Created by yfm on 2019/12/8.
//  Copyright © 2019 fm y. All rights reserved.
//

#import "FMLoadingPlugin.h"

@implementation FMLoadingPlugin

+ (void)willSend {
    NSLog(@"=========== start loading ===========");
}

+ (void)didReceive:(FMResponse *)response {
    NSLog(@"=========== end loading ===========");
}

@end
