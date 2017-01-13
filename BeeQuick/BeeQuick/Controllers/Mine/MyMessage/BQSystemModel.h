//
//  BQSystemModel.h
//  BeeQuick
//
//  Created by 郭选 on 2016/12/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQSystemModel : NSObject

// "“0元起送”新时代"
@property (nonatomic, copy)NSString *title;

//"站内信： 亲爱的用户： 您好，北京即日起爱鲜蜂首次开启“0元起送”新时代，全场订单0元起送，当日22点前收货不满30元收取5元运费，22点后不满50元收取10元运费，新鲜预订商品下单不满30元收取5元运费，满30元免运费。 "
@property (nonatomic, copy)NSString *content;


//增加是否显示全部数据的属性
@property(nonatomic,assign)BOOL isShowAll;

@end
