//
//  ViewOfCustomerTableViewCell.m
//  GDSASYS
//
//  Created by windzhou on 15/3/27.
//  Copyright (c) 2015年 Smart-Array. All rights reserved.
//

#import "AXFViewOfCustomerTableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AXFViewOfCustomerTableViewCell
@synthesize drscriptionLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        drscriptionLabel = [[UILabel alloc] init];
        drscriptionLabel.backgroundColor = [UIColor clearColor];
        drscriptionLabel.textColor = [UIColor darkGrayColor];
        drscriptionLabel.font = [UIFont systemFontOfSize:12.f];
        drscriptionLabel.textAlignment = NSTextAlignmentLeft;
        drscriptionLabel.numberOfLines = 0;
        [self.contentView addSubview:drscriptionLabel];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:lineView];
        
        [drscriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.leading.mas_equalTo(self).offset(10);
            make.trailing.mas_equalTo(-10);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.bottom.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
