//
//  BQCostDetailCell.m
//  BeeQuick
//
//  Created by Mac on 16/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQCostDetailCell.h"

@interface BQCostDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *costDetailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *costDetailPriceLabel;

@end

@implementation BQCostDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setCostDetailPrice:(float)costDetailPrice {
    
    self.costDetailPriceLabel.text = [NSString stringWithFormat:@"%.2f",costDetailPrice];
}

- (void)setCostDetailTitle:(NSString *)costDetailTitle {
    self.costDetailTitleLabel.text = costDetailTitle;
}

@end
