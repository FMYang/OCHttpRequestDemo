//
//  User.h
//  FMHttpRequest
//
//  Created by fm y on 2019/12/2.
//  Copyright © 2019 fm y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) int age;

@end

NS_ASSUME_NONNULL_END
