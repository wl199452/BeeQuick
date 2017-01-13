//
//  BQProductCountView.h
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BQProduct;
@interface BQProductCountView : UIControl

@property (nonatomic, assign) NSInteger count;

//当前选择的商品
@property (nonatomic, strong) BQProduct *selectedProduct;

// 分辨是点击了增加还是减少
@property (nonatomic, assign) BOOL isClickedIncrement;

@end
