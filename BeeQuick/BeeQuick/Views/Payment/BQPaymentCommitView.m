//
//  BQPaymentCommitView.m
//  BeeQuick
//
//  Created by Mac on 16/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQPaymentCommitView.h"

@interface BQPaymentCommitView ()
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@end

@implementation BQPaymentCommitView

+ (instancetype)paymentCommitView {
    return [[[NSBundle mainBundle] loadNibNamed:@"BQPaymentCommitView" owner:nil options:nil] lastObject];
}

- (void)setTotalPrice:(float)totalPrice {
    
    _totalPrice = totalPrice;
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
}

- (IBAction)commitPayment:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commitPayment)]) {
        [self.delegate commitPayment];
    }
}

@end
