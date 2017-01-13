//
//  BQSelAddressViewController.h
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQAddressModel.h"
typedef void(^ModifyDeliveryAddressBlock)(NSString *);


@interface BQSelAddressViewController : UIViewController
//@property(copy,nonatomic)NSString *addressString;

@property (nonatomic, copy) ModifyDeliveryAddressBlock modifyDeliveryAddressBlock;
@property(strong,nonatomic)NSMutableArray <BQAddressModel *> *addressArray;
@end
