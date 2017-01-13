//
//  BQTicketModel.h
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQTicketModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *status;


- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
