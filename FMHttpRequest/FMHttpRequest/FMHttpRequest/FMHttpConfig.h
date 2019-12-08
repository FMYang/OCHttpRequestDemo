//
//  FMHttpConfig.h
//  FMHttpRequest
//
//  Created by fm y on 2019/11/29.
//  Copyright © 2019 fm y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMHttpPluginDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FMRequestSerializerType) {
    /// 使用HTTP格式序列化请求参数
    FMRequestSerializerTypeHTTP,
    /// 使用JSON格式序列化请求参数
    FMRequestSerializerTypeJSON,
    /// 使用PropertyList格式序列化请求参数
    FMRequestSerializerTypePropertyList
};

@interface FMHttpConfig : NSObject

+ (instancetype)shared;

/// 数据对应的key，默认为"data"
@property (nonatomic, copy) NSString *dataKey;

/// 状态码对应的key，默认为"code"
@property (nonatomic, copy) NSString *codeKey;

/// message对应的key，默认为"message"
@property (nonatomic, copy) NSString *messageKey;

/// 成功业务状态码，默认为"200"
@property (nonatomic, copy) NSString *successCode;

/// 超时时间，默认30秒
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/// 请求头，默认为@{}
@property (nonatomic, strong) NSDictionary *httpRequestHeaders;

/// 解析器类，默认使用FMParse
@property (nonatomic, strong) Class parseClass;

/// 插件
@property (nonatomic, strong) NSArray<id<FMHttpPluginDelegate>> *plugins;

@end

NS_ASSUME_NONNULL_END