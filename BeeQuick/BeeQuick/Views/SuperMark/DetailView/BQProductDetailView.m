//
//  BQProductDetailView.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQProductDetailView.h"
#import<UIImageView+WebCache.h>

@interface BQProductDetailView ()

//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Product;

//商品名称
@property (weak, nonatomic) IBOutlet UILabel *lbl_ProductName;
//商品实际价格
@property (weak, nonatomic) IBOutlet UILabel *lbl_Partner_price;
//划线价格
@property (weak, nonatomic) IBOutlet UILabel *lbl_Market_price;
//商品活动
@property (weak, nonatomic) IBOutlet UIButton *lbl_Desc;
//商品品牌
@property (weak, nonatomic) IBOutlet UIButton *lbl_Brand_name;
//商品重量
@property (weak, nonatomic) IBOutlet UIButton *lbl_specifics;

//划线
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Line;

/** 买一增一高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pm_desc_Height_cons;
@property (weak, nonatomic) IBOutlet UIToolbar *pm_desc_ToolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarHeightCons;

@end


@implementation BQProductDetailView

+(instancetype)productDetailView{
    return [[[NSBundle mainBundle]loadNibNamed:@"BQProductDetailView" owner:self options:nil] lastObject];
}

-(void)setDetailModel:(BQProduct *)detailModel{
    _detailModel = detailModel;
    
    [self.imageView_Product sd_setImageWithURL:[NSURL URLWithString:detailModel.img] placeholderImage:IMAGE(@"v2_orderSuccess")];
    
    self.lbl_ProductName.text = detailModel.name;
   
    if (detailModel.partner_price != detailModel.market_price) {
        self.lbl_Market_price.text = [NSString stringWithFormat:@"¥%@",detailModel.market_price];
        self.lbl_Market_price.alpha = 1;
        self.imageView_Line.alpha = 1;
    }else{
        self.lbl_Market_price.alpha = 0;
        self.imageView_Line.alpha = 0;
    }
    
    self.lbl_Partner_price.text = [NSString stringWithFormat:@"¥%@",detailModel.partner_price];
    
    if (self.detailModel.pm_desc.length > 0) {
        
        //[self.lbl_Desc setTitle:[NSString stringWithFormat:@"%@ (赠品有限，赠完为止)",detailModel.pm_desc] forState:UIControlStateNormal];
        self.pm_desc_ToolBar.hidden = NO;
    } else {
        self.pm_desc_ToolBar.hidden = YES;
        self.pm_desc_Height_cons.constant = 0;
        self.toolBarHeightCons.constant = 300 - 52;
    }
    [self.lbl_Brand_name setTitle:detailModel.brand_name forState:UIControlStateNormal];
    [self.lbl_specifics setTitle:detailModel.specifics forState:UIControlStateNormal];
    
}



@end
