//
//  FMHttpPlugDelegate.h
//  FMHttpRequest
//
//  Created by yfm on 2019/12/8.
//  Copyright © 2019 fm y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResponse.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FMHttpPluginDelegate <NSObject>

@optional

+ (void)willSend;

+ (void)didReceive:(FMResponse *)response;

@end

NS_ASSUME_NONNULL_END
