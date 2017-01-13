//
//  BQOrderDetailModel.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQOrderDetailModel.h"
#import "BQStatusModel.h"
#import "BQFeeModel.h"
#import "BQOrderGoodsModel.h"

@implementation BQOrderDetailModel

- (NSString *)description {
    
    return [self yy_modelDescription];
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    
    return @{@"status_timeline":[BQStatusModel class],
             @"fee_list":[BQFeeModel class]
             };
}

@end
