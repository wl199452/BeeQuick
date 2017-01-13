//
//  BQPaymentProductCell.m
//  BeeQuick
//
//  Created by Mac on 16/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQPaymentProductCell.h"
#import "BQProduct.h"

@interface BQPaymentProductCell ()

/** 是否是精选Label*/
@property (weak, nonatomic) IBOutlet UILabel *is_xf_Label;
/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
/** 商品购买数量 */
@property (weak, nonatomic) IBOutlet UILabel *productChoseCountLabel;
/** 此商品的总价格 */
@property (weak, nonatomic) IBOutlet UILabel *productTotalPriceLabel;


/** 赠送商品的View */
@property (weak, nonatomic) IBOutlet UIView *presentView;

/** 赠品是否是精选的标签 */
@property (weak, nonatomic) IBOutlet UILabel *is_xf_Present_Label;

/** 赠品商品的名称 */
@property (weak, nonatomic) IBOutlet UILabel *productName_Present_Label;

/** 赠品商品的数量 */
@property (weak, nonatomic) IBOutlet UILabel *productCount_Present_Label;


//约束
/** 精选Label的宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *is_xf_Width_Cons;
/** 赠品视图中精选标签宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *is_xf_Present_Width_Cons;

/** 买一增一视图高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *presentViewHeightCons;


@end


@implementation BQPaymentProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.productName_Present_Label.preferredMaxLayoutWidth = 150;
}

- (void)setProduct:(BQProduct *)product {
    
    _product = product;
    self.productNameLabel.text = self.product.name;
    self.productChoseCountLabel.text = [NSString stringWithFormat:@"x%zd",[product.hasChoseCount integerValue]];
    self.productTotalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[product.hasChoseCount integerValue] * [product.partner_price floatValue] ];
    
    //是否显示精选Label
    self.is_xf_Label.hidden = ![product.is_xf integerValue];
    self.is_xf_Width_Cons.constant = ([product.is_xf integerValue] ? 40 : 0);
    
    //是否显示买一增一
    if (!product.pm_desc.length) {
        self.presentView.hidden = YES;
        self.presentViewHeightCons.constant = 8;
    } else {
        self.presentView.hidden = NO;
        self.presentViewHeightCons.constant = 34;
        
        self.is_xf_Present_Label.hidden = ![product.is_xf integerValue];
        self.is_xf_Present_Width_Cons.constant = ([product.is_xf integerValue] ? 40 : 0);
        
        self.productName_Present_Label.text = [NSString stringWithFormat:@"%@[赠]",product.name];
        
        self.productCount_Present_Label.text = [NSString stringWithFormat:@"x%zd",[product.hasChoseCount integerValue]];
    }
}

@end
