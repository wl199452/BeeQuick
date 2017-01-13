//
//  BQTabBarController.h
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQTabBarController : UITabBarController

//- (void)setBadgeValueWithBadgeString:(NSString *)badgeString;

/** 购物车的中心 */
@property (readonly, nonatomic, assign) CGPoint shoppingCarCenter;

@end
