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
//#import "FMParse.h"
#import "FMHttpParseDelegate.h"
#import "FMError.h"

NS_ASSUME_NONNULL_BEGIN

#define FMSuccessBlock(type) void (^)(type result, FMResponse *response)

typedef void(^FMFailBlock)(FMError *error);

@interface FMHttpManager : NSObject

@property (nonatomic, strong, readonly) AFURLSessionManager *manager;

// json转model的解析器，默认使用MJExtension
@property (nonatomic, strong) id<FMHttpParseDelegate> parse;

/// 单例
+ (FMHttpManager *)shared;

/// 发起网络请求
/// @param request 请求对象
/// @param success 成功
/// @param fail 失败
+ (void)sendRequest:(FMRequest *)request
            success:(FMSuccessBlock(id))success
               fail:(FMFailBlock)fail;

@end

NS_ASSUME_NONNULL_END
