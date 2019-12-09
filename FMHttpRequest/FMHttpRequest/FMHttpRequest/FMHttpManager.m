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
#import "FMError.h"

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

+ (void)sendRequest:(FMRequest *)request completeHandler:(void (^)(FMResponse * _Nonnull response))complete {
    [[self shared] sendRequest:request completeHandler:complete];
}

- (void)sendRequest:(FMRequest *)request
    completeHandler:(nonnull void (^)(FMResponse *response))complete {
    // FMRequest -> NSURLRequest
    [self dataTaskWithRequest:request completeHandler:complete];
}

// 请求参数序列化 FMRequest -> NSURLRequest
- (NSMutableURLRequest *)serializerRequest:(FMRequest *)request {
    AFHTTPRequestSerializer *serialize = [AFHTTPRequestSerializer serializer];
    NSError *serializationError = nil;
    NSURL *baseUrl = [NSURL URLWithString:request.baseUrl];
    NSString *requestUrl = [[NSURL URLWithString:request.path relativeToURL:baseUrl] absoluteString];
    NSMutableURLRequest *urlRequest = [serialize requestWithMethod:[request requestMethod]
                                                         URLString:requestUrl
                                                        parameters:request.params error:&serializationError];

    return urlRequest;
}

- (void)dataTaskWithRequest:(FMRequest *)request
            completeHandler:(nonnull void (^)(FMResponse *response))complete {
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
        NSString *dataKey = [FMHttpConfig shared].dataKey;
        NSString *successCode = [FMHttpConfig shared].successCode;
        id responseCode = responseObject[codeKey];

        FMResponse *fmResponse = nil;
        FMError *fmError = nil;

        if(error) {
            // http请求失败处理
            fmError = [FMError processError:error];
        } else {
            // http请求成功，业务逻辑处理
            // 业务请求成功，响应的code与服务的成功状态码对比
            BOOL bussinessSuccess = NO;
            if([responseCode isKindOfClass:[NSString class]]) {
                if([responseCode isEqualToString:successCode]) {
                    bussinessSuccess = YES;
                }
            } else if([responseCode isKindOfClass:[NSNumber class]]) {
                if([responseCode intValue] == [successCode intValue]) {
                    bussinessSuccess = YES;
                }
            }
            
            if(bussinessSuccess) {
                id data = responseObject[dataKey];
                fmResponse = [FMResponse processResult:response responseObject:data request:request error:error];
            } else {
                // 业务失败处理，走错误回调
                fmError = [FMError processError:error];
            }
        }
        
        // 插件didReceive方法
        NSArray *plugins = [[FMHttpConfig shared] plugins];
        [plugins enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj respondsToSelector:@selector(didReceive:)]) {
                [obj didReceive:fmResponse];
            }
        }];
        
        complete(fmResponse);
    }];
    [task resume];
}

@end
