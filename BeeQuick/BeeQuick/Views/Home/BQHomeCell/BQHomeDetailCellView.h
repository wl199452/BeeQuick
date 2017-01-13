//
//  BQHomeDetailCellView.h
//  BeeQuick
//
//  Created by 王林 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BQProduct;
@interface BQHomeDetailCellView : UIView

+(instancetype)homeDetailCellView;

@property(nonatomic,strong)BQProduct *productModel;

//商品实际价格
@property (weak, nonatomic) IBOutlet UILabel *lbl_Partner_price;

//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
