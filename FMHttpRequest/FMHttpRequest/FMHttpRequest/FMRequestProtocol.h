//
//  FMRequestProtocol.h
//  FMHttpRequest
//
//  Created by yfm on 2020/7/3.
//  Copyright © 2020 com.yfm.network. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FMRequestProtocol <NSObject>

@required

/// http请求方法
@property (nonatomic, assign) FMHttpReuqestMethod method;

/// 请求url
@property (nonatomic, copy) NSString *path;

/// 请求baseUrl
@property (nonatomic, copy) NSString *baseUrl;

/// 请求参数
@property (nonatomic, strong) NSDictionary *params;


@optional

@end

NS_ASSUME_NONNULL_END
