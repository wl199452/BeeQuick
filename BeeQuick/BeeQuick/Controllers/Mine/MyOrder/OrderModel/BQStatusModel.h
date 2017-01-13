//
//  BQStatusModel.h
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQStatusModel : NSObject


/*
 "status_timeline":[
 {
 "status_time":"16:38",
 "status_title":"已完成",
 "status_desc":"订单已完成，快来评价吧"
 },
 {
 "status_time":"16:19",
 "status_title":"已发货",
 "status_desc":"%商家电话%:{13161315336}"
 },
 ]
 */

@property (nonatomic, copy)NSString *status_time;

@property (nonatomic, copy)NSString *status_title;

@property (nonatomic, copy)NSString *status_desc;

@end
