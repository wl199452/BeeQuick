//
//  BQOrderDetailModel.h
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BQOrderGoodsModel;

@class BQStatusModel;

@class BQFeeModel;

@interface BQOrderDetailModel : NSObject

//订单状态
@property (nonatomic, strong) NSArray <BQStatusModel*>*status_timeline;

//订单号
@property (nonatomic, copy)NSString *order_no;

//收获码
@property (nonatomic, copy)NSString *checknum;

//下单时间
@property (nonatomic, copy)NSString *create_time;

//配送时间
@property (nonatomic, copy)NSString *accept_time;

//配送方式

//支付方式

//备注信息

//收货人
@property (nonatomic, copy)NSString *accept_name;

//电话
@property (nonatomic, copy)NSString *mobile;

@property (nonatomic, copy)NSString *telphone;

//收货地址
@property (nonatomic, copy)NSString *address;

//配送超时
@property (nonatomic, copy)NSString *dealer_name;

//订单里的商品
@property(nonatomic,strong)NSArray <NSArray<BQOrderGoodsModel*>*>* order_goods;

//fee_list 配送费 服务费 优惠券
@property(nonatomic,strong)NSArray <BQFeeModel*> *fee_list;

//实付
@property (nonatomic, copy)NSString *user_pay_amount;

//评价
@property (nonatomic, copy)NSString *comment;

//✨数目
@property(nonatomic,copy)NSNumber *star;

//共几件商品
@property(nonatomic,copy)NSNumber *buy_num;


////上面信息的数组
//@property(nonatomic,strong)NSArray<NSString *>*strArray;



@end
