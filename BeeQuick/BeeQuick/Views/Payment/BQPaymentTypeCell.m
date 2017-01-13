//
//  BQPaymentTypeCell.m
//  BeeQuick
//
//  Created by Mac on 16/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQPaymentTypeCell.h"

@interface BQPaymentTypeCell ()
/** 支付方式图片 */
@property (weak, nonatomic) IBOutlet UIImageView *paymentTypeImageView;

/** 支付方式 */
@property (weak, nonatomic) IBOutlet UILabel *paymentTypeTitleLabel;

/** 选择支付方式button */
@property (weak, nonatomic) IBOutlet UIButton *selectPaymentButton;

@end


@implementation BQPaymentTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setPaymentTypeTitle:(NSString *)paymentTypeTitle {
    
    _paymentTypeTitle = paymentTypeTitle;
    
    self.paymentTypeTitleLabel.text = paymentTypeTitle;
}

- (void)setPaymentTypeIamge:(UIImage *)paymentTypeIamge {
    
    _paymentTypeIamge = paymentTypeIamge;
    
    self.paymentTypeImageView.image = paymentTypeIamge;
}

- (void)setIsSelected:(BOOL)isSelected {
    
    self.selectPaymentButton.selected = isSelected;
}

@end
