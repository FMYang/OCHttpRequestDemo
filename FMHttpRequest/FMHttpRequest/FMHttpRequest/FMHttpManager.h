//
//  FMHttpManager.h
//  FMHttpRequest
//
//  Created by fm y on 2019/11/29.
//  Copyright © 2019 fm y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "FMRequest.h"
#import "FMResponse.h"
#import "FMParse.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMHttpManager : NSObject

@property (nonatomic, strong, readonly) AFURLSessionManager *manager;

// json转model的解析器，默认使用MJExtension
@property (nonatomic, strong) id<FMHttpParseDelegate> parse;

/// 单例
+ (FMHttpManager *)shared;

/// 发起网络请求
/// @param request 请求对象
/// @param complete 请求完成回调
- (void)sendRequest:(FMRequest *)request
    completeHandler:(void(^)(FMResponse *response))complete;

+ (void)sendRequest:(FMRequest *)request
completeHandler:(void(^)(FMResponse *response))complete;

@end

NS_ASSUME_NONNULL_END
