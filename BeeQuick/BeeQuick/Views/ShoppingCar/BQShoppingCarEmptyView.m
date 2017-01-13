//
//  BQShoppingCarEmptyView.m
//  BeeQuick
//
//  Created by Mac on 16/12/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQShoppingCarEmptyView.h"

@implementation BQShoppingCarEmptyView

+ (instancetype)shoppingCarEmptyView {
    return [[[NSBundle mainBundle] loadNibNamed:@"BQShoppingCarEmptyView" owner:nil options:nil] lastObject];
}

- (IBAction)goShopping:(UIButton *)sender {
    if (self.goShopping) {
        self.goShopping();
    }
}


@end
