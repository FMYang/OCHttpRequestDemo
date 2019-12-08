//
//  FMRequest.h
//  FMHttpRequest
//
//  Created by fm y on 2019/11/29.
//  Copyright © 2019 fm y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FMHttpReuqestMethod) {
    FMHttpReuqestMethodGet,
    FMHttpReuqestMethodPost,
    FMHttpReuqestMethodPut,
    FMHttpReuqestMethodDelete
};

@interface FMRequest : NSObject

/// 最终请求对象
@property (nonatomic, strong) NSMutableURLRequest *request;

/// http请求方法
@property (nonatomic, assign) FMHttpReuqestMethod method;

/// 请求url
@property (nonatomic, copy) NSString *path;

/// 请求baseUrl
@property (nonatomic, copy) NSString *baseUrl;

/// 请求参数
@property (nonatomic, strong) NSDictionary *params;

/// 响应模型类，网络请求的JSON转成哪个模型
@property (nonatomic, assign) Class responseClass;

/// 请求方法字符串，请求序列化的时候用到
- (NSString *)requestMethod;
@end

NS_ASSUME_NONNULL_END
