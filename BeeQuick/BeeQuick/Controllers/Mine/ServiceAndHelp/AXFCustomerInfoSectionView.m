//
//  CustomerInfoSectionView.m
//  GDSASYS
//
//  Created by windzhou on 15/3/30.
//  Copyright (c) 2015年 Smart-Array. All rights reserved.
//

#import "AXFCustomerInfoSectionView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation AXFCustomerInfoSectionView
@synthesize nameLabel,managerNameLabel,departmentLabel,addressLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWithNameLabel:(NSString*)name ManagerNameLabel:(NSString*)managerName DepartmentLabel:(NSString*)department AddressLabel:(NSString*)address section:(NSInteger)sectionNumber delegate:(id <CustomerInfoSectionViewDelegate>)delegate
{
    self.delegate = delegate;
    self.section = sectionNumber;
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = UIColorFromRGB(0x333333);
    nameLabel.font = [UIFont systemFontOfSize:16.f];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = name;
    [self addSubview:nameLabel];
    

    _arrow = [[UIImageView alloc]init];
    _arrow.backgroundColor = [UIColor clearColor];
    _arrow.image = [UIImage imageNamed: @"cell_arrow_down_accessory"];
    [self addSubview:_arrow];
    [_arrow sizeToFit];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49.f, CGRectGetWidth([UIScreen mainScreen].applicationFrame), 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:lineView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.trailing.mas_equalTo(10);
    }];
    
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.mas_equalTo(self);
        make.trailing.mas_equalTo(-10);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _isOpen = NO;
}

-(void)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction {
    //判断所在sectionView是否打开来旋转箭头
    _isOpen = !_isOpen;
    if (userAction) {
        if (_isOpen) {
            [UIView animateWithDuration:.3 animations:^{
                self.arrow.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            [UIView animateWithDuration:.3 animations:^{
                self.arrow.transform = CGAffineTransformIdentity;
            }];
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}


@end
