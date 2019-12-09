//
//  FMResponse.h
//  FMHttpRequest
//
//  Created by fm y on 2019/11/29.
//  Copyright © 2019 fm y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FMRequest;

typedef NS_ENUM(NSUInteger, FMResponseState) {
    /// 成功
    FMResponseStateSuccess,
    /// 失败
    FMResponseStateFail
};

@interface FMResponse : NSObject

/// 请求对象
@property (nonatomic, strong) FMRequest *request;

/// 原始请求对象
@property (nonatomic, strong) NSURLRequest *orignalrequest;

/// 响应对象
@property (nonatomic, strong) NSURLResponse *response;

/// 响应数据
@property (nonatomic, strong) id responseObject;

/// 响应状态码
@property (nonatomic, assign) FMResponseState state;

/// code
@property (nonatomic, assign) int code;

/// message
@property (nonatomic, copy) NSString *message;

/// data
@property (nonatomic, strong) id _Nullable data;

/// 包装响应结果
/// @param response <#response description#>
/// @param responseObject <#responseObject description#>
/// @param request <#request description#>
/// @param error <#error description#>
+ (FMResponse *)processResult:(NSURLResponse *)response
               responseObject:(id)responseObject
                      request:(FMRequest *)request
                        error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
