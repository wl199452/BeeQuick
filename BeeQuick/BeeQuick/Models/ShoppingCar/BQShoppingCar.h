//
//  BQShoppingCar.h
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BQProduct;

#define _ShoppingCar ([BQShoppingCar sharedShoppingCar])

@interface BQShoppingCar : NSObject
/** 购物车单例 */
+ (instancetype)sharedShoppingCar;

/** 购物车中商品总量 */
@property(readonly, nonatomic, assign) NSInteger totalCount;

/** 购物车商品总价格 */
@property (readonly, nonatomic, assign) CGFloat totalPrice;

/** 即将提交时的共价格 */ /** 即商品在购物车中被选中，即将付款的状态 */
@property (readonly, nonatomic, assign) CGFloat commitPrice;

/** 向购物车添加一件商品 */
- (void)addProduct:(BQProduct *)product;

/** 删除购物车中一个商品 */
- (void)removeProduct:(BQProduct *)product;

/** 购物车中所有商品 */
- (NSArray<BQProduct *> *)productInShoppingCar;

/** 收货地址 */
@property (nonatomic, copy) NSString *receiveAddress;

@end
