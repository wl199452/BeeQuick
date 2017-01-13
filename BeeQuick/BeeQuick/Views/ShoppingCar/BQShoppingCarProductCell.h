//
//  BQShoppingCarProductCell.h
//  BeeQuick
//
//  Created by Mac on 16/12/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BQProduct;
@class BQShoppingCarProductCell;
@protocol BQShoppingCarProductCellDelegate <NSObject>

/** 是否选择某一款商品 */
- (void)shoppingCarProductCell:(BQShoppingCarProductCell *)cell isChoseProductType:(BOOL)isChose;

@end


@interface BQShoppingCarProductCell : UITableViewCell

@property (nonatomic, strong) BQProduct *product;

@property (nonatomic, weak) id<BQShoppingCarProductCellDelegate> delegate;

@end
