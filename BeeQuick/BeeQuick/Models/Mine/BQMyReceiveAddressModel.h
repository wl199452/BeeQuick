//
//  BQMyReceiveAddressModel.h
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQAddressModel.h"

@interface BQMyReceiveAddressModel : NSObject

-(void)loadAddressDataWithCompleteBlock:(void(^)(NSArray <BQAddressModel *>*addressArray))completeBlock;
@end


/*
 
 
 http://iosapi.itcast.cn/loveBeen/MyAdress.json.php
 call = 12
 {
 "id": "4351645",
 "accept_name": "维尼的小熊",
 "telphone": "18833331111",
 "province_id": "1",
 "province_name": "北京",
 "city_id": "2",
 "city_name": "北京市",
 "district_id": "0",
 "district_name": "",
 "address": "人民大会堂 9527办公室",
 "lng": "116.43704865748",
 "lat": "39.927583644703",
 "lng_map": "116.43704865748",
 "lat_map": "39.927583644703",
 "isnew": "1",
 "version": "2",
 "addr_for_dealer": "西水井胡同1号",
 "gender": "1"
 },
 */
