//
//  BQProductDetailView.h
//  BeeQuick
//
//  Created by 王林 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQProduct.h"
@interface BQProductDetailView : UIView

@property(nonatomic,strong)BQProduct *detailModel;

+(instancetype)productDetailView;

@end
