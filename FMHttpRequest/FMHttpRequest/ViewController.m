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
    // https://api.apiopen.top/getJoke?page=1&count=2&type=video （实时段子,神评版本）
    // https://api.asilu.com/today/ (历史上的今天)
    
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
    
    // 1、request
    [self fetchList:params success:^(NSArray<VideoModel *> *result, FMResponse *response) {

    } fail:^(FMError * _Nonnull error) {

    }];
    
    // 2、upload file
    [self uploadFile];
}

// post请求 封装
- (void)fetchList:(NSDictionary *)params success:(FMSuccessBlock(NSArray<VideoModel *> *))success fail:(FMFailBlock)fail {
    FMRequest *request = FMRequest.build()
    .reqUrl(@"/getJoke")
    .reqParams(params)
    .resultClass(VideoModel.class)
    .reqDataFormat(FMRequestDataFormatDefault)
    .resSampleData([self readJson:@"Video"]);
    
    [FMHttpManager sendRequest:request success:success fail:fail];
}

// post请求 直接
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


#pragma mark - 上传文件
- (NSDictionary *)commonRequestHeader {
    return @{@"X-ZY-Platform": @"iOS",
             @"X-ZY-Production": @"zycami",
             @"X-ZY-Version": @"1.0.8"};
}

- (void)uploadFile {
    NSDictionary *params = @{@"access_token": @"ChFvYXV0aC5hY2Nlc3NUb2tlbhJQeXge6V-szsN0rcHvikBOFWkkcNfc87sUFpiGHweLFs7US0YwOBhZ1tKligcooHQ9TiWqfmz_tLSZWWEjRcPPvGc4yg5G9FNOSlSwY9-3PfkaEi12HLC4YkSGiKG1_lVAiiG5ayIgo-eVKYaal6jYnM-l7n2vWG_PB5Y5D-EjYBheLTwIdVcoBTAB",
                             @"others": @"{\"bizId\":\"zhiyun\",\"appid\":\"ks680887970458072564\",\"caption\":\"\",\"streamType\":\"video\"}",
                             @"platform" : @"kuaishou",
                             @"user_token": @"53231c2fc7a8c9820ed12fe868870489",
                             @"userid": @"1862257"};
    
    FMFileInfo *info = [[FMFileInfo alloc] init];
    UIImage *image = [UIImage imageNamed:@"test1"];
    info.data = UIImagePNGRepresentation(image);
    info.name = @"file";
    info.fileName = @"cover.jpg";
    info.mimeType = @"image/png";
    
    FMRequest *request = FMRequest.build()
    .reqBaseUrl(@"https://service.zhiyun-tech.com")
    .reqUrl(@"/public/v1/livevideo/publish")
    .reqParams(params)
//    .reqHttpHeader([self commonRequestHeader])
    .reqFileInfos(@[info]);
    
    [FMHttpManager uploadFile:request progress:^(NSProgress * _Nonnull progress) {
        NSLog(@"completedUnitCount = %lld, totalUnitCount = %ld, progress = %f ", progress.completedUnitCount, progress.totalUnitCount, 1.0 * progress.completedUnitCount / progress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"finished %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"error %@", error);
    }];
}

@end
