//
//  BQOrderCellViewModel.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQOrderCellViewModel.h"
#import "BQOrderDetailModel.h"
#import "BQOrderGoodsModel.h"
#import "BQStatusModel.h"

@implementation BQOrderCellViewModel

- (void)setModel:(BQOrderDetailModel *)model {
    
    _model = model;
    
    self.create_time = model.create_time;
    
    self.buyNumStr = [NSString stringWithFormat:@"共%@件商品",model.buy_num];
    
    self.userBuyStr = [NSString stringWithFormat:@"实付: $%@",model.user_pay_amount];
    
    self.status_timeline = model.status_timeline;
    
    NSMutableArray *arrTemp = [NSMutableArray array];
    
    for (NSArray *arr1 in model.order_goods) {
        
        BQOrderGoodsModel *goodModel = arr1[0];
        
        NSURL *url = [NSURL URLWithString:goodModel.img];
        
        [arrTemp addObject:url];
    }
    self.imageUrls = arrTemp.copy;
    
    //订单详情属性
    self.order_noStr = [NSString stringWithFormat:@"订单号     %@",model.order_no];
    
    self.checknumStr = [NSString stringWithFormat:@"收货码     %@",model.checknum];
    
    self.create_timeStr = [NSString stringWithFormat:@"下单时间  %@",model.create_time];
    
    self.accept_timeStr = [NSString stringWithFormat:@"配送时间  %@",model.accept_time];
    
    self.methodStr = @"配送方式  送货上门";
    //accept_time
    self.payStr = @"支付方式  在线支付";
    
    self.remarkStr = @"备注信息";
    
    //放到数组里
    self.strArr = @[self.order_noStr,self.checknumStr,self.create_timeStr,self.accept_timeStr,self.methodStr,self.payStr,self.remarkStr];
    
 
    
}



@end
