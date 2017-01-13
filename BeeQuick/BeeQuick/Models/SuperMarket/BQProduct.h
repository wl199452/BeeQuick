//
//  BQProduct.h
//  BeeQuick
//
//  Created by 王林 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 商品状态 */
typedef NS_ENUM(NSUInteger, ProductStatus) {
    kProductNotDefined = 0,     //未定义状态，初始化时的状态
    kProductInShoppingCar,      //在购物车中，商品加入购物车中的初始状态
    kProductWillBePurchased,    //商品即将被购买，商品在购物车中被选择即将支付时
    kProductAlreadyPurchased,   //商品已经支付完成的状态
};


@interface BQProduct : NSObject

//商品名称
@property(nonatomic,copy)NSString *name;

//商品库存
//@property(nonatomic,copy)NSString *store_nums;

//品牌名称
@property(nonatomic,copy)NSString *brand_name;

//商品重量
@property(nonatomic,copy)NSString *specifics;

//商品划线售价
@property(nonatomic,copy)NSString *market_price;

//商品实际售价
@property(nonatomic,copy)NSString *partner_price;

//最大购买量
@property(nonatomic,copy)NSString *number;

//商品图片地址
@property(nonatomic,copy)NSString *img;

//商品描述(买一赠一)
@property(nonatomic,copy)NSString *pm_desc;

//标识是否精选(1->精选) 0->不是精选
@property(nonatomic,copy)NSNumber *is_xf;


//@property(nonatomic, copy)NSNumber *had_pm;

/** 已经选择的数量 */
@property (nonatomic, copy)NSNumber *hasChoseCount;

/** 商品状态 */
@property (nonatomic, assign) ProductStatus productStatus;

@end
