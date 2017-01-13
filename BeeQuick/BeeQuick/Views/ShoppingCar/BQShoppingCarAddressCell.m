//
//  BQShoppingCarAddressCell.m
//  BeeQuick
//
//  Created by Mac on 16/12/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQShoppingCarAddressCell.h"

@interface BQShoppingCarAddressCell ()
/** 收货人 */
@property (weak, nonatomic) IBOutlet UILabel *consigneeLabel;
/** 收货人电话 */
@property (weak, nonatomic) IBOutlet UILabel *consigneeNumberLabel;
/** 收货人性别 */
@property (weak, nonatomic) IBOutlet UILabel *consigneeGenderLabel;
/** 收货人地址 */
@property (weak, nonatomic) IBOutlet UILabel *consigneeAddressLabek;

@end

@implementation BQShoppingCarAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
