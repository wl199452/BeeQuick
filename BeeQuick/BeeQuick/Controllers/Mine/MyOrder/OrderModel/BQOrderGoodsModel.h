//
//  BQOrderGoodsModel.h
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQOrderGoodsModel : NSObject


//三全珍鲜灌汤水饺三鲜
@property (nonatomic, copy)NSString *name;

//数目
@property (nonatomic, copy)NSString *goods_nums;

//7.50
@property (nonatomic, copy)NSString *goods_price;

//http://img01.bqstatic.com/upload/goods/000/001/1290/0000011290_78300.jpg@200w_200h_90Q.jpg 商品图片
@property (nonatomic, copy)NSString *img;

#pragma mark - order_goods里的数组有两个的话是精选
//精选1,普通0
@property (nonatomic, copy)NSNumber *isgift;

@end
