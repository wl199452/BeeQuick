//
//  BQNetWorkTools.h
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, MethodType) {
    GET,
    POST,
};

@interface BQNetWorkTools : AFHTTPSessionManager

+ (instancetype) sharedTools;

- (void) requestWithMethodType:(MethodType )methodType urlString:(NSString *)urlString parameters:(id )paremeters finishedCallBackBlock:(void(^)(id responseObject, NSError* error))finishedCallBackBlock;



@end
