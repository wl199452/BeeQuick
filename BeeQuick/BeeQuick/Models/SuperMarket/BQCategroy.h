//
//  BQCategroy.h
//  BeeQuick
//
//  Created by 王林 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQProduct.h"

@interface BQCategroy : NSObject

// 分类id
@property(nonatomic,copy)NSString *cid;

//分类名称
@property(nonatomic,copy)NSString *name;

//product 商品信息

@property(nonatomic,strong)NSMutableArray<BQProduct *>*productArr;


@end
