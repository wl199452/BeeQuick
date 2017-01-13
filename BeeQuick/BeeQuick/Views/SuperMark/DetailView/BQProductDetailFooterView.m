//
//  BQProductDetailFooterView.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQProductDetailFooterView.h"
#import "BQProductCountView.h"
#import "BQProduct.h"

@interface BQProductDetailFooterView ()
@property (weak, nonatomic) IBOutlet BQProductCountView *productCountView;
@property (weak, nonatomic) IBOutlet UILabel *supplymentLabel;
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UILabel *badgeCountLabel;

@end

@implementation BQProductDetailFooterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.productCountView addTarget:self action:@selector(productCountViewDidClicked:) forControlEvents:UIControlEventValueChanged];
    
    //KVO监听商品被选择的数量
    [self addObserver:self forKeyPath:@"product.hasChoseCount" options:NSKeyValueObservingOptionNew context:nil];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shoppingCarTotalCountChangedNotification:) name:ShoppingCarTotalCountChangedNotification object:nil];
    self.badgeView.hidden = !_ShoppingCar.totalCount;
    self.badgeCountLabel.text = [NSString stringWithFormat:@"%zd",_ShoppingCar.totalCount];
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
    self.badgeCountLabel.text = [NSString stringWithFormat:@"%zd",totalCount];
    
    self.badgeView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:6 options:0 animations:^{
        self.badgeView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

#pragma mark -
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    self.productCountView.count = [self.product.hasChoseCount integerValue];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"product.hasChoseCount"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark 发出通知
- (void)productCountViewDidClicked:(BQProductCountView *)sender {
    
    if (sender.isClickedIncrement) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ProductCountIncreaseNotification object:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ProductCountReduceNotification object:self];
    }
}


+(instancetype)productDetailFooterView{
    return [[[NSBundle mainBundle]loadNibNamed:@"BQProductDetailFooterView" owner:self options:nil] lastObject];
}

- (IBAction)shoppingCarDidClicked:(UIButton *)sender {
    
    //弹出购物车
    if (self.showshoppingCarBlock) {
        self.showshoppingCarBlock();
    }
}

- (void)setProduct:(BQProduct *)product {
    
    _product = product;
    
    self.supplymentLabel.hidden = [product.number integerValue];
    self.productCountView.hidden = ![product.number integerValue];
    self.productCountView.count = [product.hasChoseCount integerValue];
}


@end
