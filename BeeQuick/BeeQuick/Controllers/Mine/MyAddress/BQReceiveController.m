//
//  BQReceiveController.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQReceiveController.h"

@interface BQReceiveController ()

@end

@implementation BQReceiveController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"我的收货地址";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setNav];
    
    [self setupAddLocationView];

    
}

-(void)setNav
{
    
    // 左上角返回按钮
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v2_goback"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark
#pragma mark - 新增地址
- (void)setupAddLocationView
{
    //创建
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];
    
    UIButton *btn = [[UIButton alloc] init];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"v2_coupon_verify_normal"] forState:UIControlStateNormal];
    
    [btn setTitle:@"+新增地址" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(pushToAddLocatonViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    
    //约束
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(60);
        
        make.left.bottom.right.mas_equalTo(self.view);
        
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(view);
        
        make.width.mas_equalTo(250);
        
        make.height.mas_equalTo(40);
    }];

}

#pragma mark - 点击事件
- (void)pushToAddLocatonViewController:(UIButton *)button
{

    NSLog(@"222");

}

@end
