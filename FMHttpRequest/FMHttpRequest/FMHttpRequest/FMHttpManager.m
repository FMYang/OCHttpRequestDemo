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
        // 设置默认解析器
        [instance setupParse:[instance defaultParse]];
    });
    return instance;
}

- (AFURLSessionManager *)manager {
    if(!_manager) {
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
    }
    return _manager;
}

- (id<FMHttpParseDelegate>)defaultParse {
    FMParse *parse = [[FMParse alloc] init];
    return parse;
}

- (void)setupParse:(id<FMHttpParseDelegate>)parse {
    self.parse = parse;
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
    urlRequest.timeoutInterval = 15.0;
    
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
        responseObject = responseObject[@"result"];
        FMResponse *fmResponse;
        if (error) {
            fmResponse = [[FMResponse alloc] init];
            fmResponse.state = FMResponseStateFail;
            fmResponse.data = nil;
        } else {
            id result = [self.parse mapJSON:responseObject cls:request.responseClass];
            fmResponse = [[FMResponse alloc] init];
            fmResponse.data = result;
        }
        NSLog(@"%ld", [((NSHTTPURLResponse *)response) statusCode]);
        fmResponse.response = response;
        fmResponse.responseObject = responseObject;
        fmResponse.orignalrequest = urlRequest;
        
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
