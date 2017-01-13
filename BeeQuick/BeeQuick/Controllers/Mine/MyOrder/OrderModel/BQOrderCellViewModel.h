//
//  BQOrderCellViewModel.h
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BQOrderDetailModel;

@class BQStatusModel;

@interface BQOrderCellViewModel : NSObject

@property(nonatomic,strong)BQOrderDetailModel *model;

//创建时间
@property(nonatomic,copy)NSString *create_time;

//总共购买
@property(nonatomic,copy)NSString *buyNumStr;

//实付
@property(nonatomic,copy)NSString *userBuyStr;

//商品图片合集
@property(nonatomic,strong)NSArray<NSURL*> *imageUrls;


//订单状态
@property (nonatomic, strong) NSArray <BQStatusModel*>*status_timeline;

//订单号
@property(nonatomic,strong)NSString *order_noStr;

//收获码
@property (nonatomic, copy)NSString *checknumStr;

//下单时间
@property (nonatomic, copy)NSString *create_timeStr;

//配送时间
@property (nonatomic, copy)NSString *accept_timeStr;

//配送方式
@property(nonatomic,copy)NSString *methodStr;

//支付方式
@property(nonatomic,copy)NSString *payStr;

//备注信息
@property(nonatomic,copy)NSString *remarkStr;

//收货人
@property (nonatomic, copy)NSString *accept_nameStr;

//收货地址
@property (nonatomic, copy)NSString *addressStr;

//配送超市
@property (nonatomic, copy)NSString *dealer_nameStr;


//上面信息的数组
@property(nonatomic,strong)NSArray<NSString *>*strArr;

@end
