//
//  BQGoodsInfoModes.h
//  BeeQuick
//
//  Created by 王林 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BQCategroy;
@class BQProduct;

@interface BQGoodsInfoModes : NSObject

//categeroy 数据
- (void)getCategeroyInfoCompleteBlock:(void(^)(NSArray<BQCategroy *>* CategroyRes))completeBlock;

//product 数据

//-(void)getProductInfoWithCompleteBlock:(void(^)(NSArray <BQProduct*>*res, NSError *error ))completeBlock;

@end
