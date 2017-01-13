//
//  BQNetWorkTools.m
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQNetWorkTools.h"

@interface BQNetWorkTools ()

@end

static BQNetWorkTools* _instance;

@implementation BQNetWorkTools

+ (instancetype) sharedTools {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc]init];
        
        //增加一个可以接收的类型
        _instance.responseSerializer.acceptableContentTypes = [ _instance.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        _instance.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    return _instance;
}


- (void) requestWithMethodType:(MethodType )methodType urlString:(NSString *)urlString parameters:(id )paremeters finishedCallBackBlock:(void(^)(id responseObject, NSError* error))finishedCallBackBlock {
    
    void(^successBlock)(NSURLSessionDataTask* dataTask, id responseObject) = ^(NSURLSessionDataTask* dataTask, id responseObject){
        
        finishedCallBackBlock(responseObject, nil);
    };
    
    void(^failureBlock)(NSURLSessionDataTask* dataTask, NSError* error) = ^(NSURLSessionDataTask* dataTask, NSError* error){
        
        finishedCallBackBlock(nil, error);
        NSLog(@"%@",error);
    };
    
    if (methodType == GET) {
        
        
        [self GET:urlString parameters:paremeters progress:nil success: successBlock failure: failureBlock];
        
    } else {
        
        [self POST:urlString parameters:paremeters progress:nil success:successBlock failure:failureBlock];
    }
}

@end
