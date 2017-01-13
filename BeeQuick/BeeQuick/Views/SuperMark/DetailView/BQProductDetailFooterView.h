//
//  BQProductDetailFooterView.h
//  BeeQuick
//
//  Created by 王林 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShowShoppingCarBlock)();

@interface BQProductDetailFooterView : UIView

@property (nonatomic, strong) BQProduct *product;

+(instancetype)productDetailFooterView;

@property (nonatomic, copy) ShowShoppingCarBlock showshoppingCarBlock;

@end
