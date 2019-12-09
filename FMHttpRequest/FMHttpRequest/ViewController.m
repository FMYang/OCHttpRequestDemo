//
//  ViewController.m
//  FMHttpRequest
//
//  Created by fm y on 2019/11/29.
//  Copyright © 2019 fm y. All rights reserved.
//

#import "ViewController.h"
#import "FMHttpHeader.h"
#import "User.h"
#import "CustomParse.h"
#import "VideoModel.h"
#import "CustomRequest.h"
#import "FMLoadingPlugin.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    config.parse = [[FMParse alloc] init];
    config.baseURL = @"https://api.apiopen.top";
    
    CustomRequest *request = [[CustomRequest alloc] initWithPage:1
                                                           count:2
                                                            type:@"video"];
    [FMHttpManager sendRequest:request success:^(FMResponse * _Nonnull response) {
        NSLog(@"code: %@", response.code);
        NSLog(@"message: %@", response.message);
        NSLog(@"data: %@", response.data);
    } fail:^(FMError * _Nonnull error) {
        NSLog(@"code: %@", error.code);
        NSLog(@"message: %@", error.message);
        NSLog(@"error: %@", error.error);
    }];
}


@end
