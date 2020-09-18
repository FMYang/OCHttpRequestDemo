//
//  FMLoadingPlugin.m
//  FMHttpRequest
//
//  Created by yfm on 2019/12/8.
//  Copyright © 2019 fm y. All rights reserved.
//

#import "FMLoadingPlugin.h"

@implementation FMLoadingPlugin

+ (void)willSend:(FMRequest *)request {
    NSLog(@"=========== start loading ===========");
}

+ (void)didReceive:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    NSLog(@"=========== end loading ===========");
}

@end
