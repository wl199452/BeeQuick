//
//  BQHomeDetailCellView.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQHomeDetailCellView.h"
#import "BQProduct.h"
#import <UIImageView+WebCache.h>
#import "BQProductCountView.h"

@interface BQHomeDetailCellView ()


//商品名称
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
//是否精选
@property (weak, nonatomic) IBOutlet UIImageView *imgview_jx;

//买一赠一
@property (weak, nonatomic) IBOutlet UIImageView *imagView_Desc;

//商品重量
@property (weak, nonatomic) IBOutlet UILabel *lbl_Specifics;

//商品划线价格
@property (weak, nonatomic) IBOutlet UILabel *lbl_Market_price;

//划线Img
@property (weak, nonatomic) IBOutlet UIImageView *limageView_line;

/** 购物车计数按钮 */
@property (weak, nonatomic) IBOutlet BQProductCountView *productCountView;

/** 补货中Label */
@property (weak, nonatomic) IBOutlet UILabel *supplementLabel;

@end

@implementation BQHomeDetailCellView

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

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"productModel.hasChoseCount"];
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


+(instancetype)homeDetailCellView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"BQHomeDetailCellView" owner:self options:nil] lastObject];
    
}

-(void)setProductModel:(BQProduct *)productModel{
    _productModel = productModel;
    
    self.lbl_Name.text = productModel.name;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:productModel.img] placeholderImage:[UIImage imageNamed:@"v2_orderSuccess"]];
    
    self.lbl_Specifics.text = productModel.specifics;
    self.lbl_Partner_price.text =  [NSString stringWithFormat:@"¥%@",productModel.partner_price];
    
    if (productModel.partner_price != productModel.market_price) {
        self.lbl_Market_price.text = [NSString stringWithFormat:@"¥%@",productModel.market_price];
        self.lbl_Market_price.hidden = YES;
        self.limageView_line.hidden = YES;
    }else{
        self.lbl_Market_price.hidden = NO;
        self.limageView_line.hidden = NO;
    }

    
    self.imagView_Desc.hidden = !productModel.pm_desc.length;
    
    self.supplementLabel.hidden = [productModel.number integerValue];
    self.productCountView.hidden = ![productModel.number integerValue];
}






@end
