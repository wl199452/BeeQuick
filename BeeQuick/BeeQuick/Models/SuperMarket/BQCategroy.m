//
//  BQCategroy.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQCategroy.h"
#import <YYModel.h>


@implementation BQCategroy



+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"cid":@"id"};
}


-(NSString *)description{
    return  [self yy_modelDescription];
}

@end
