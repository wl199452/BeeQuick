//
//  BQShoppingCarButton.m
//  BeeQuick
//
//  Created by Mac on 16/12/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQShoppingCarButton.h"

@interface BQShoppingCarButton ()
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UILabel *badgeValueLabel;

@end

@implementation BQShoppingCarButton

+ (instancetype)shoppingCarButton {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"BQShoppingCarButton" owner:nil options:nil] lastObject];
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.badgeView.hidden = !_ShoppingCar.totalCount;
    self.badgeValueLabel.text = [NSString stringWithFormat:@"%zd",_ShoppingCar.totalCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shoppingCarTotalCountChangedNotification:) name:ShoppingCarTotalCountChangedNotification object:nil];
}


#pragma mark -
#pragma mark 处理通知
- (void)shoppingCarTotalCountChangedNotification:(NSNotification *)notification {
    
    NSInteger totalCount = [notification.userInfo[kShoppingCarTotalCount] integerValue];
    
    [self setBadgeValueWithTotalCount:totalCount];
}

- (void)setBadgeValueWithTotalCount:(NSInteger)totalCount {
    
    if (totalCount < 0) {
        return;
    }
    self.badgeView.hidden = !totalCount;
    self.badgeValueLabel.text = [NSString stringWithFormat:@"%zd",totalCount];
    
    self.badgeView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:6 options:0 animations:^{
        self.badgeView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

- (IBAction)shoppingCarDidClicked:(UIButton *)sender {
    
    //弹出购物车
    if (self.showshoppingCarBlock) {
        self.showshoppingCarBlock();
    }
}

- (void)setProductCount:(NSInteger)productCount {
    
    _productCount = productCount;
}

@end
