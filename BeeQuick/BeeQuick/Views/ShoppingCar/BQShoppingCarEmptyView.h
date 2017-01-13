//
//  BQShoppingCarEmptyView.h
//  BeeQuick
//
//  Created by Mac on 16/12/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GoShopping)();

@interface BQShoppingCarEmptyView : UIView

+ (instancetype)shoppingCarEmptyView;

@property (nonatomic, copy) GoShopping goShopping;

@end
