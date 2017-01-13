//
//  BQSelAddressViewController.m
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQSelAddressViewController.h"
#import "BQUpdateAddressVC.h"


@interface BQSelAddressViewController ()
@property(weak,nonatomic)UIImageView *nullImageView;
@property(weak,nonatomic)UIView *bottomAddAddressView;
@end

@implementation BQSelAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
    [self setupNavigationItem];
    [self setupNullImageView];
    [self setupBottomAddAddressButton];
    
    
}

#pragma mark - setupNavigationItem
-(void)setupNavigationItem{
    self.navigationItem.title = @"我的收货地址";
    
}

#pragma mark - setupNullImageView
-(void)setupNullImageView{
    UIImageView *nullImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - SCREEN_WIDTH / 9.0, self.view.center.y - SCREEN_WIDTH / 4.5, SCREEN_WIDTH / 4.5, SCREEN_WIDTH / 4.5)];
    nullImageView.image = [UIImage imageNamed:@"v2_address_empty"];
    _nullImageView = nullImageView;
    [self.view addSubview:nullImageView];
    
    UILabel *nullLabel = [[UILabel alloc]init];
    nullLabel.text = @"您还没有地址哦😯~";
    [nullLabel.font fontWithSize:12];
    nullLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:nullLabel];
    [nullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nullImageView.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(self.nullImageView);
    }];
    
}
#pragma mark - setupBottomAddAddressButton
-(void)setupBottomAddAddressButton{
    
    UIView *bottomAddAddressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTabBarH)];
    bottomAddAddressView.backgroundColor = [UIColor whiteColor];
    _bottomAddAddressView = bottomAddAddressView;
    [self.view addSubview:bottomAddAddressView];
    [bottomAddAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(kTabBarH);
    }];
    
    UIButton *bottomAddAddressButton = [[UIButton alloc]init];
    [bottomAddAddressButton setTitle:@"+ 新增地址" forState:UIControlStateNormal];
    [bottomAddAddressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomAddAddressButton setBackgroundImage:[UIImage imageNamed:@"icon_sendcoupon"] forState:UIControlStateNormal];
    [bottomAddAddressButton addTarget:self action:@selector(clickAddAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    
    bottomAddAddressButton.titleLabel.font =
    [UIFont systemFontOfSize:16];
    
    [self.bottomAddAddressView addSubview:bottomAddAddressButton];
    [bottomAddAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomAddAddressView);
        make.width.mas_equalTo(SCREEN_WIDTH / 1.2);
        make.height.mas_equalTo(kTabBarH - 10);
    }];
}

-(void)clickAddAddressBtn{
    [self.navigationController pushViewController:[BQUpdateAddressVC new] animated:YES];
}

@end
