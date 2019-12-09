//
//  FMResponse.m
//  FMHttpRequest
//
//  Created by fm y on 2019/11/29.
//  Copyright © 2019 fm y. All rights reserved.
//

#import "FMResponse.h"
#import "FMRequest.h"
#import "FMHttpConfig.h"

@implementation FMResponse

+ (FMResponse *)processResult:(NSURLResponse *)response
               responseObject:(id)responseObject
                      request:(FMRequest *)request
                        error:(NSError *)error {
    id parse = [FMHttpConfig shared].parse;
    id result;
    if(parse) {
        result = [parse mapJSON:responseObject cls:request.responseClass];
    } else {
        result = responseObject;
    }
    FMResponse *fmResponse = [[FMResponse alloc] init];
    fmResponse.request = request;
    fmResponse.data = result;
    fmResponse.response = response;
    fmResponse.responseObject = responseObject;
    fmResponse.orignalrequest = request.request;
    return fmResponse;
}

@end
