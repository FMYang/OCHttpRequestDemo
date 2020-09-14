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

/// 请求超时时间
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/// 请求头
@property (nonatomic, strong) NSDictionary *httpHeader;

/// 公共参数
@property (nonatomic, strong) NSDictionary *publicParams;

/// 响应模型类，网络请求的JSON转成哪个模型
@property (nonatomic, assign) Class responseClass;

/// 插桩数据
@property (nonatomic, strong) id sampleData;

/// 请求方法字符串，请求序列化的时候用到
- (NSString *)requestMethod;

#pragma mark - 链式函数

+ (FMRequest * (^)(void))build;
- (FMRequest * (^)(FMHttpReuqestMethod))reqMethod;
- (FMRequest * (^)(NSString * _Nullable))reqBaseUrl;
- (FMRequest * (^)(NSString * _Nullable))reqUrl;
- (FMRequest * (^)(NSDictionary * _Nullable))reqParams;
- (FMRequest * (^)(Class _Nullable))resultClass;
- (FMRequest * (^)(NSData * _Nullable))resSampleData;

@end

NS_ASSUME_NONNULL_END
