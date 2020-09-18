//
//  ViewController.m
//  FMHttpRequest
//
//  Created by fm y on 2019/11/29.
//  Copyright © 2019 fm y. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "CustomParse.h"
#import "VideoModel.h"
#import "CustomRequest.h"
#import "FMLoadingPlugin.h"
#import "FMHttpHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self readJson:@"Video"];
    
    // https://api.apiopen.top/getJoke?page=1&count=2&type=video （实时段子,神评版本）
    // https://api.asilu.com/today/ (历史上的今天)
    // 模拟数据
//    FMRequest *request = [[FMRequest alloc] init];
//    request.method = FMHttpReuqestMethodPost;
//    request.baseUrl = @"https://api.apiopen.top";
//    request.path = @"/getJoke";
//    request.params = @{@"page":@1, @"count":@10, @"type":@"video"};
//    request.responseClass = [VideoModel class];
    
    // 设置网络
    FMHttpConfig *config = [FMHttpConfig shared];
    config.dataKey = @"result";
    config.plugins = @[[FMHttpLogger class], [FMLoadingPlugin class]];
    config.parse = [[CustomParse alloc] init];
    config.baseURL = @"https://api.apiopen.top";
    config.publicParams = @{@"version": @"2.0"};
    config.publicRequestHeaders = @{@"userAgent_t": @"agent"};
    config.dataFormat = FMRequestDataFormatDefault;
    
    NSDictionary *params = @{@"page": @(1),
                             @"count": @(2),
                             @"type": @"video"};

    
    // 1、直接用
//    FMRequest *request = [[FMRequest alloc] init];
//    request.path = @"/getJoke";
//    request.method = FMHttpReuqestMethodPost;
//    request.params = params;
    
    // 2、缺点：需要继承，个人不喜欢
//    CustomRequest *request = [[CustomRequest alloc] initWithPage:1
//                                                           count:2
//                                                            type:@"video"];
    
    
//    // 3、缺点，没有Xcode补全，换行也蛋疼
//    FMRequest *request = FMRequest.build()
//                                .reqUrl(@"/getJoke")
//                                .reqMethod(FMHttpReuqestMethodPost)
//                                .reqParams(params);
//
//    [FMHttpManager sendRequest:request success:^(FMResponse * _Nonnull response) {
////        NSLog(@"code: %@", response.code);
////        NSLog(@"message: %@", response.message);
////        NSLog(@"data: %@", response.data);
//    } fail:^(FMError * _Nonnull error) {
////        NSLog(@"code: %@", error.code);
////        NSLog(@"message: %@", error.message);
////        NSLog(@"error: %@", error.error);
//    }];
    
    // 1
    [self fetchList:params success:^(NSArray<VideoModel *> *result, FMResponse *response) {

    } fail:^(FMError * _Nonnull error) {

    }];
    
    // 2
//    [self fetchList];
}

- (void)fetchList:(NSDictionary *)params success:(FMSuccessBlock(NSArray<VideoModel *> *))success fail:(FMFailBlock)fail {
    FMRequest *request = FMRequest.build()
    .reqUrl(@"/getJoke")
    .reqParams(params)
    .resultClass(VideoModel.class)
    .reqDataFormat(FMRequestDataFormatDefault)
    .resSampleData([self readJson:@"Video"]);
    
    [FMHttpManager sendRequest:request success:success fail:fail];
}

//- (void)fetchList:(NSDictionary *)params {
//    FMRequest *request = FMRequest.build()
//    .reqUrl(@"/getJoke")
//    .reqParams(params)
//    .resultClass(VideoModel.class)
//    .resSampleData([self readJson:@"Video"]);
//
//    [FMHttpManager sendRequest:request success:^(id  _Nonnull result, FMResponse * _Nonnull response) {
//
//    } fail:^(FMError * _Nonnull error) {
//
//    }];
//}

- (id)readJson:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if([NSJSONSerialization isValidJSONObject:object]) {
        return object;
    }
    return nil;
}

@end
