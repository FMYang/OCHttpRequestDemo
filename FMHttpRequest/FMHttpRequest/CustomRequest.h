//
//  CustomRequest.h
//  FMHttpRequest
//
//  Created by fmy on 2019/12/6.
//  Copyright © 2019 fm y. All rights reserved.
//

#import "FMRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomRequest : FMRequest

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int count;
@property (nonatomic, copy) NSString *type;

- (instancetype)initWithPage:(int)page
                       count:(int)count
                        type:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
