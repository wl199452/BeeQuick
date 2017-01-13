//
//  BQUpdateAddressVC.h
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BQAddressModel;
@interface BQUpdateAddressVC : UIViewController

@property (nonatomic, strong) BQAddressModel *infoModel;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy) void(^deleteCurrentAddressBlock)(BQAddressModel *);

@end
