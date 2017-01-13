//
//  BQShoppingCarStatisticsView.h
//  BeeQuick
//
//  Created by Mac on 16/12/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BQShoppingCarStatisticsViewDelegate <NSObject>

/** 是否选择所有商品 */
- (void)shoppingCarStatisticsViewSelectAllProduct:(BOOL)isSelectAllProduct;

- (void)commitOrder;

@end



@interface BQShoppingCarStatisticsView : UIView

+ (instancetype)ShoppingCarStatisticsView;
/** 总价钱 */
@property (nonatomic, assign) float totalPrice;

@property (nonatomic, weak) id<BQShoppingCarStatisticsViewDelegate> delegate;

@end
