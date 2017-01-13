//
//  BQShoppingCarStatisticsView.m
//  BeeQuick
//
//  Created by Mac on 16/12/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQShoppingCarStatisticsView.h"

@interface BQShoppingCarStatisticsView ()
/** 全选按钮 */
@property (weak, nonatomic) IBOutlet UIButton *allSeclectButton;
/** 总价钱 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
/** 提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@end

@implementation BQShoppingCarStatisticsView


+ (instancetype)ShoppingCarStatisticsView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"BQShoppingCarStatisticsView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setTotalPrice:(float)totalPrice {
    
    _totalPrice = totalPrice;
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",totalPrice];

    if (totalPrice == 0.0) {
        self.commitButton.enabled = NO;
        [self.commitButton setBackgroundColor:[UIColor darkGrayColor]];
        [self.commitButton setTitle:@"满￥0起送" forState:UIControlStateNormal];
    } else {
        self.commitButton.enabled = YES;
        [self.commitButton setBackgroundColor:kMainColor];
        [self.commitButton setTitle:@"选好了" forState:UIControlStateNormal];
    }
    
    if (_ShoppingCar.totalPrice - totalPrice > 0.001) {
        self.allSeclectButton.selected = NO;
    } else {
        self.allSeclectButton.selected = YES;
    }
}

/** 全选 */
- (IBAction)selectAllProducts:(UIButton *)sender {
    
    if (sender.isSelected) {
        if ([self.delegate respondsToSelector:@selector(shoppingCarStatisticsViewSelectAllProduct:)]) {
            [self.delegate shoppingCarStatisticsViewSelectAllProduct:NO];
            sender.selected = NO;
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(shoppingCarStatisticsViewSelectAllProduct:)]) {
            [self.delegate shoppingCarStatisticsViewSelectAllProduct:YES];
            sender.selected = YES;
        }
    }
    
}

/** 提交 */
- (IBAction)commit:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(commitOrder)]) {
        [self.delegate commitOrder];
    }
}

@end
