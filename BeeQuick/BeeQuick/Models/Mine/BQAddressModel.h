//
//  BQAddressModel.h
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQAddressModel : NSObject<NSCoding>

@property(nonatomic,copy)NSString *accept_name;
@property(nonatomic,copy)NSString *telphone;
@property(nonatomic,copy)NSString *province_name;
//所在城市
@property(nonatomic,copy)NSString *city_name;
//所在地区
@property(nonatomic,copy)NSString *address;
//详细地址
@property(nonatomic,copy)NSString *addr_for_dealer;
//性别
@property(nonatomic,copy)NSString *gender;

+ (NSArray<BQAddressModel *> *) unarchiver;
+ (void) archiver:(NSArray<BQAddressModel *> *) array;

@end

