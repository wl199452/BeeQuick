//
//  BQHeadView.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQHeadView.h"
#import "NSAttributedString+ZFBAdditon.h"

@implementation BQHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{
    
    [self addButtonsWithImageName:@"v2_my_order_icon" title:@"我的订单" tag:kButtonOrder];
    
    [self addButtonsWithImageName:@"v2_my_coupon_icon" title:@"优惠劵" tag:kButtonTicket];
    
    [self addButtonsWithImageName:@"v2_my_message_icon" title:@"我的消息" tag:kButtonMessage];
    
    [self setupLineView];
    
    [self setupLineView];
    
    
    
}

- (void)setupLineView {
    
    UIView *lineView = [UIView new];
    
    lineView.backgroundColor = [UIColor lightGrayColor];

    [self addSubview:lineView];
}

- (void)addButtonsWithImageName:(NSString *)imageName title:(NSString *)title tag:(HomeTopButtonType)tag{
    
    //添加四个按钮
    UIButton *button = [[UIButton alloc]init];
    
    //设置按钮的属性,实现图文混排
    [button setAttributedTitle:[NSAttributedString cz_imageTextWithImage:[UIImage imageNamed:imageName] imageW:35 imageH:25 title:title fontSize:14 titleColor:[UIColor grayColor] spacing:7] forState:UIControlStateNormal];
    
    button.titleLabel.numberOfLines = 0;
    
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [button sizeToFit];
    
    button.tag = tag;
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
}

- (void)clickButton:(UIButton *)button{
    
    NSDictionary *info = @{@"clickedButton":button};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickTopButton" object:self userInfo:info];
    
}

- (void)layoutSubviews{
    
    //必须要调用super父类的方法
    [super layoutSubviews];
    
    CGFloat width = (SCREEN_WIDTH - 2)/3;
    
    CGFloat height = 60;
    
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([subView isKindOfClass:NSClassFromString(@"UIButton")]) {
            
            CGFloat x = idx * (width + 1);
            
            subView.frame = CGRectMake(x, 8, width, height);
        }
        
        if ([subView isMemberOfClass:NSClassFromString(@"UIView")]) {
            
            subView.frame = CGRectMake( (idx -2 ) * width, 8, 1, 50);
            
        }
    }];
    
}



@end
