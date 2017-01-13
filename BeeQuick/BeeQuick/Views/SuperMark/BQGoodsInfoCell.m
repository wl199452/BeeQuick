//
//  BQGoodsInfoCell.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQGoodsInfoCell.h"
#import "BQProduct.h"
#import  <UIImageView+WebCache.h>
#import "BQProductCountView.h"

@interface BQGoodsInfoCell ()
/** 精选图标的宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xf_width;

/** 精选与title之间的间距约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xf_intervalxf_;

/** 计数view */
@property (weak, nonatomic) IBOutlet BQProductCountView *productCountView;

/** 补充货物Label */
@property (weak, nonatomic) IBOutlet UILabel *supplementLabel;


@end

@implementation BQGoodsInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.productCountView addTarget:self action:@selector(productCountViewDidClicked:) forControlEvents:UIControlEventValueChanged];
    
    //KVO监听商品被选择的数量
    [self addObserver:self forKeyPath:@"productModel.hasChoseCount" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark -
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    self.productCountView.count = [self.productModel.hasChoseCount integerValue];
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

#pragma mark -
#pragma mark 给Cell赋值
-(void)setProductModel:(BQProduct *)productModel{
    _productModel = productModel;
    
    NSURL *imgURL = [NSURL URLWithString:productModel.img];
    [self.productImgView sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"v2_placeholder_square"]];
    
    self.lbl_ProductName.text = productModel.name;
    self.lbl_partner_price.text = [NSString stringWithFormat:@"¥%@",productModel.partner_price];
    self.lbl_specifics.text = productModel.specifics;
    
    self.imgView_Desc.hidden = !productModel.pm_desc.length;

    if ([productModel.is_xf intValue]) {
        self.imgView_xf.alpha = 1;
        self.xf_width.constant = 30;
        self.xf_intervalxf_.constant = 8;
        self.lbl_ProductName.numberOfLines = 0;
    }else{
        self.imgView_xf.alpha = 0;
        self.xf_width.constant = 0;
        self.xf_intervalxf_.constant = 0;
        self.lbl_ProductName.numberOfLines = 1;
    }
 
    if (productModel.partner_price != productModel.market_price) {
        self.lbl_Market_Price.text = [NSString stringWithFormat:@"¥%@",productModel.market_price];
        self.lbl_Market_Price.alpha = 1;
        self.line_ImgView.alpha = 1;
    }else{
        self.lbl_Market_Price.alpha = 0;
        self.line_ImgView.alpha = 0;
    }
    
    self.supplementLabel.hidden = [productModel.number integerValue];
    self.productCountView.hidden = ![productModel.number integerValue];


    //设置每个商品被选择的数量
    self.productCountView.count = [productModel.hasChoseCount integerValue];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"productModel.hasChoseCount"];
}

@end
