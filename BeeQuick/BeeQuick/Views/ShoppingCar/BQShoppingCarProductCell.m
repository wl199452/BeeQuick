//
//  BQShoppingCarProductCell.m
//  BeeQuick
//
//  Created by Mac on 16/12/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQShoppingCarProductCell.h"
#import "BQProductCountView.h"
#import <UIImageView+WebCache.h>
#import "BQProduct.h"

@interface BQShoppingCarProductCell ()
/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
/** 商品价格 */
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
/** 商品商量加减视图 */
@property (weak, nonatomic) IBOutlet BQProductCountView *productCountView;
/** 选择商品的button */
@property (weak, nonatomic) IBOutlet UIButton *productSelectedButton;

@end

@implementation BQShoppingCarProductCell

- (void)awakeFromNib {
    [super awakeFromNib];

    //监听商品状态的变化
    [self addObserver:self forKeyPath:@"product.productStatus" options:NSKeyValueObservingOptionNew context:nil];
    
    //监听商品被选择的数量的变化
    [self addObserver:self forKeyPath:@"product.hasChoseCount" options:NSKeyValueObservingOptionNew context:nil];
    
    //添加点击事件监听
    [self.productCountView addTarget:self action:@selector(shoppingCarCountViewDidClicked:) forControlEvents:UIControlEventValueChanged];
}


#pragma mark -
#pragma mark 发出通知
- (void)shoppingCarCountViewDidClicked:(BQProductCountView *)sender {
    
    if (sender.isClickedIncrement) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ProductCountIncreaseNotification object:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ProductCountReduceNotification object:self];
    }
}

#pragma mark -
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"product.productStatus"]) {
        
        //通过商品状态 改变按钮选中状态
        self.productSelectedButton.selected = ([change[@"new"] integerValue] == kProductWillBePurchased);
    } else {
        //通过商品被选择的数量的变化 改变view的值
        self.productCountView.count = [self.product.hasChoseCount integerValue];
    }
}


/** 选择一款商品 */
- (IBAction)selectProductDidClicked:(UIButton *)sender {
    
    if (sender.isSelected) {
        //此款商品不计算在总价类
        if ([self.delegate respondsToSelector:@selector(shoppingCarProductCell:isChoseProductType:)]) {
            [self.delegate shoppingCarProductCell:self isChoseProductType:NO];
        }
        sender.selected = NO;
    } else {
        //此款商品要计算在总价中
        if ([self.delegate respondsToSelector:@selector(shoppingCarProductCell:isChoseProductType:)]) {
            [self.delegate shoppingCarProductCell:self isChoseProductType:YES];
        }
        sender.selected = YES;
    }
}


- (void)setProduct:(BQProduct *)product {
    
    _product = product;
 
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:product.img] placeholderImage:[UIImage imageNamed:@"v2_pullRefresh1"]];
    self.productNameLabel.text = product.name;
    self.productPriceLabel.text = product.partner_price;
    self.productCountView.count = [product.hasChoseCount integerValue];

    self.productSelectedButton.selected = (product.productStatus == kProductWillBePurchased);
}

- (void)dealloc {
    
    [self removeObserver:self forKeyPath:@"product.productStatus"];
    [self removeObserver:self forKeyPath:@"product.hasChoseCount"];
    
}
@end
