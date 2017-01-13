//
//  BQShoppingCar.m
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQShoppingCar.h"
#import "BQProduct.h"



@implementation BQShoppingCar {
    
    NSMutableArray<BQProduct *> *_productArray;
}

static BQShoppingCar *_instance;

+ (instancetype)sharedShoppingCar {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BQShoppingCar alloc]init];
    });
    return _instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _productArray = [NSMutableArray array];
    }
    return self;
}

/** 向购物车添加一件商品 */
- (void)addProduct:(BQProduct *)product {
    
    NSInteger count = [product.hasChoseCount integerValue];
    count += 1;
    product.hasChoseCount = @(count);

    if (![_productArray containsObject:product]) {
        
        [_productArray addObject:product];
        product.productStatus = kProductWillBePurchased;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ShoppingCarTotalCountChangedNotification object:self userInfo:@{kShoppingCarTotalCount : @(self.totalCount)}];
}

/** 删除购物车中一个商品 */
- (void)removeProduct:(BQProduct *)product {
    
    NSInteger count = [product.hasChoseCount integerValue];

    if (count > 0) {
        count -= 1;
        product.hasChoseCount = @(count);
        
        if (count == 0) {
            [_productArray removeObject:product];
            product.productStatus = kProductNotDefined;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ShoppingCarTotalCountChangedNotification object:self userInfo:@{kShoppingCarTotalCount : @(self.totalCount)}];
    }
}

/** 返回购物车中商品的总数量 */
- (NSInteger)totalCount {
    NSInteger count = 0;
    for (BQProduct *product in _productArray) {

        count += [product.hasChoseCount integerValue];
    }
    return count;
}

/** 返回购物车中商品的总价格 */
- (CGFloat)totalPrice {
    
    CGFloat totalPrice = 0.0;
    for (BQProduct *product in _ShoppingCar.productInShoppingCar) {
            
        totalPrice += [product.partner_price floatValue] * [product.hasChoseCount integerValue];
    }
    return totalPrice;
}


/** 返回购物车中即将支付的价格 */
- (CGFloat)commitPrice {
    
    CGFloat commitPrice = 0.0;
    for (BQProduct *product in _ShoppingCar.productInShoppingCar) {
        
        if (product.productStatus == kProductWillBePurchased) {
            
            commitPrice += [product.partner_price floatValue] * [product.hasChoseCount integerValue];
        }
    }
    return commitPrice;
}



/** 购物车中所有商品 */
- (NSArray<BQProduct *> *)productInShoppingCar {
    return _productArray.copy;
}



@end
