//
//  BQShopView.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQShopView.h"

@implementation BQShopView

+ (instancetype)loadshopView
{
    return [[[UINib nibWithNibName:@"BQShopView" bundle:nil]instantiateWithOwner:nil options:nil]lastObject];
}

@end
