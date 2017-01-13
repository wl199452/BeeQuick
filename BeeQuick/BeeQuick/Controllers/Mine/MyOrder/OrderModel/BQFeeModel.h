//
//  BQFeeModel.h
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQFeeModel : NSObject

/*
 "value":"0.00",
 "text":"配送费"
 */

@property (nonatomic, copy)NSString *value;

@property (nonatomic, copy)NSString *text;

@end
