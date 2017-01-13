//
//  BQShoppingCarButton.h
//  BeeQuick
//
//  Created by Mac on 16/12/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ShowShoppingCarBlock)();
@interface BQShoppingCarButton : UIView

+ (instancetype)shoppingCarButton;

/** 购物车商品数量 */
@property (nonatomic, assign) NSInteger productCount;

@property (nonatomic, copy) ShowShoppingCarBlock showshoppingCarBlock;
@end
