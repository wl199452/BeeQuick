//
//  BQProductCountView.m
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQProductCountView.h"
#import "UILabel+Addition.h"

@interface BQProductCountView ()

@property (nonatomic, strong) UIButton *reduceButton;
@property (nonatomic, strong) UIButton *increaseButton;
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation BQProductCountView

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self setupUI];
//    }
//    return self;
//}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setupUI];
    //NSLog(@"aweakFromNib");
}

- (void)setupUI {
    
    self.reduceButton = [self createButtonWithImageName:@"v2_reduce"];
    self.reduceButton.hidden = YES;
    [self.reduceButton addTarget:self action:@selector(reduceButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.increaseButton = [self createButtonWithImageName:@"v2_increase"];
    [self.increaseButton addTarget:self action:@selector(increaseButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.countLabel = [UILabel labelWithName:@"" font:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor]];
    [self addSubview:self.countLabel];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.hidden = YES;
    
    [self.reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.mas_equalTo(20);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(30);
        make.height.equalTo(self);
    }];
    
    [self.increaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self);
        make.width.mas_equalTo(20);
    }];
}

#pragma mark -
#pragma mark 事件
//商品数量减少
- (void)reduceButtonDidClicked {
    //self.count--;
    _isClickedIncrement = NO;
    //发送事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

//商品数量增加
- (void)increaseButtonDidClicked {
    //self.count++;
    _isClickedIncrement = YES;

    //发送事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

//设置数量
- (void)setCount:(NSInteger)count{

    _count = count;

    _reduceButton.hidden = !count;
    _countLabel.hidden = !count;

    _countLabel.text = [NSString stringWithFormat:@"%zd",count];
}


- (UIButton *)createButtonWithImageName:(NSString *)imageName {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self addSubview:button];
    [button sizeToFit];
    return button;
}

@end
