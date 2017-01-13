//
//  BQProduct.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQProduct.h"
#import <YYModel.h>

@implementation BQProduct

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化商品状态
        self.productStatus = kProductNotDefined;
    }
    return self;
}

-(NSString *)description{
    return  [self yy_modelDescription];
}

@end
