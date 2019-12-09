//
//  FMHttpManager.m
//  FMHttpRequest
//
//  Created by fm y on 2019/11/29.
//  Copyright © 2019 fm y. All rights reserved.
//

#import "FMHttpManager.h"
#import "MJExtension.h"
#import "FMResponse.h"
#import "FMHttpLogger.h"
#import "FMHttpConfig.h"
#import "FMHttpPluginDelegate.h"

@interface FMHttpManager()

@property (nonatomic, strong, readwrite) AFURLSessionManager *manager;

@end

@implementation FMHttpManager

+ (FMHttpManager *)shared {
    static FMHttpManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FMHttpManager alloc] init];
    });
    return instance;
}

- (AFURLSessionManager *)manager {
    if(!_manager) {
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
    }
    return _manager;
}

+ (void)sendRequest:(FMRequest *)request
            success:(void (^)(FMResponse * _Nonnull))success
               fail:(void (^)(FMError * _Nonnull))fail {
    [[self shared] sendRequest:request success:success fail:fail];
}

- (void)sendRequest:(FMRequest *)request
            success:(void (^)(FMResponse * _Nonnull))success
               fail:(void (^)(FMError * _Nonnull))fail {
    [self dataTaskWithRequest:request success:success fail:fail];
}

- (void)dataTaskWithRequest:(FMRequest *)request
                    success:(void (^)(FMResponse * _Nonnull))success
                       fail:(void (^)(FMError * _Nonnull))fail {
    NSMutableURLRequest *urlRequest = [self serializerRequest:request];
    // 优先使用FMRequest设置的超时时间，如果未设置，则使用配置项的
    if(request.timeoutInterval > 0) {
        urlRequest.timeoutInterval = request.timeoutInterval;
    } else {
        urlRequest.timeoutInterval = [FMHttpConfig shared].timeoutInterval;
    }
    
    // 插件willSend方法
    NSArray *plugins = [[FMHttpConfig shared] plugins];
    [plugins enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj respondsToSelector:@selector(willSend)]) {
            [obj willSend];
        }
    }];
    
    __block NSURLSessionDataTask *task = nil;
    task = [self.manager dataTaskWithRequest:urlRequest
                       uploadProgress:nil
                     downloadProgress:nil
                    completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        /*
         responseObject应该遵送restAPi规范，与服务端约定好格式{"code":0, "message":"", "data":{}}
         */
        NSString *codeKey = [FMHttpConfig shared].codeKey;
        NSString *messageKey = [FMHttpConfig shared].messageKey;
        NSString *dataKey = [FMHttpConfig shared].dataKey;
        NSString *successCode = [FMHttpConfig shared].successCode;
        
        // 业务状态码NSString类型接收
        NSString *responseCode = @"";
        if([responseObject[codeKey] isKindOfClass:[NSString class]]) {
            responseCode = responseObject[codeKey];
        } else if([responseObject[codeKey] isKindOfClass:[NSNumber class]]) {
            responseCode = [NSString stringWithFormat:@"%ld", [responseObject[codeKey] integerValue]];
        }
        NSString *message = responseObject[messageKey];
        id data = responseObject[dataKey];

        FMResponse *fmResponse = nil;
        FMError *fmError = nil;

        if(error) {
            // http请求失败处理
            fmError = [FMError processError:error];
            fmError.code = responseCode;
            fmError.message = message;
            fmError.data = data;
            fail(fmError);
        } else {
            // http请求成功，业务逻辑处理
            // 业务请求成功，响应的code与服务的成功状态码对比
            BOOL bussinessSuccess = NO;
            if([responseCode isEqualToString:successCode]) {
                bussinessSuccess = YES;
            }
            
            if(bussinessSuccess) {
                fmResponse = [FMResponse processResult:response responseObject:data request:request error:error];
                fmResponse.code = responseCode;
                fmResponse.message = message;
                success(fmResponse);
            } else {
                // 业务失败处理，走错误回调
                fmError = [FMError processError:error];
                fmError.code = responseCode;
                fmError.message = message;
                fmError.data = data;
                fail(fmError);
            }
        }
        
        // 插件didReceive方法
        NSArray *plugins = [[FMHttpConfig shared] plugins];
        [plugins enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj respondsToSelector:@selector(didReceive:responseObject:error:)]) {
                [obj didReceive:task responseObject:responseObject error:error];
            }
        }];
    }];
    [task resume];
}

// 请求参数序列化 FMRequest -> NSURLRequest
// 构造请求对象
- (NSMutableURLRequest *)serializerRequest:(FMRequest *)request {
    AFHTTPRequestSerializer *serialize = [AFHTTPRequestSerializer serializer];
    NSError *serializationError = nil;
    
    NSURL *baseURL;
    // 优先使用FMRequest设置的baseURL，如果为设置，则使用默认配置的URL
    if(request.baseUrl.length > 0) {
        baseURL = [NSURL URLWithString:request.baseUrl];
    } else if([FMHttpConfig shared].baseURL.length > 0) {
        baseURL = [NSURL URLWithString:[FMHttpConfig shared].baseURL];
    } else {
        @throw @"未设置服务器服务器地址";
    }
    NSString *requestUrl = [[NSURL URLWithString:request.path relativeToURL:baseURL] absoluteString];
    NSMutableURLRequest *urlRequest = [serialize requestWithMethod:[request requestMethod]
                                                         URLString:requestUrl
                                                        parameters:request.params error:&serializationError];

    return urlRequest;
}

- (BOOL)networkReachable {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end
