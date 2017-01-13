//
//  BQDeliveryTitleView.m
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQDeliveryTitleView.h"

@interface BQDeliveryTitleView ()
@property (weak, nonatomic) IBOutlet UILabel *deliveryToLabel;
@end

@implementation BQDeliveryTitleView

-(void)awakeFromNib{
    [super awakeFromNib];

    self.deliveryToLabel.layer.borderWidth = 1;
    self.deliveryToLabel.layer.borderColor = [UIColor blackColor].CGColor;
}

@end
