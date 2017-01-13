//
//  BQGoodsInfoCell.h
//  BeeQuick
//
//  Created by 王林 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BQProduct;

@interface BQGoodsInfoCell : UITableViewCell

@property(nonatomic,strong)BQProduct *productModel;

//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *productImgView;

//商品名称
@property (weak, nonatomic) IBOutlet UILabel *lbl_ProductName;

//商品实际售价
@property (weak, nonatomic) IBOutlet UILabel *lbl_partner_price;

//商品划线价格
@property (weak, nonatomic) IBOutlet UILabel *lbl_Market_Price;

//划线
@property (weak, nonatomic) IBOutlet UIImageView *line_ImgView;

//买一赠一标识
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Desc;

//是否精选
@property (weak, nonatomic) IBOutlet UIImageView *imgView_xf;

//商品重量
@property (weak, nonatomic) IBOutlet UILabel *lbl_specifics;
@end
