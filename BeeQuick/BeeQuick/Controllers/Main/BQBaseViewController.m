//
//  BQBaseViewController.m
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQBaseViewController.h"
#import "BQDeliveryTitleView.h"
#import "BQScanViewController.h"
#import "BQSearchViewController.h"
#import "BQSelAddressViewController.h"


@interface BQBaseViewController ()
@property(nonatomic,strong) BQDeliveryTitleView *deliveryTitleView;
@end

@implementation BQBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackScanItem];
    [self setupDeliveryItem];
    [self setupSearchItem];
    self.navigationController.navigationBar.barTintColor = kMainColor;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (!_ShoppingCar.receiveAddress) {
        [self.deliveryTitleView.deliveryButton setTitle:@"你在哪里呀" forState:UIControlStateNormal];
    } else {
        [self.deliveryTitleView.deliveryButton setTitle:_ShoppingCar.receiveAddress forState:UIControlStateNormal];
    }
}

#pragma mark - 导航栏扫一扫按钮
- (void)setupBackScanItem{
    
    UIButton *backScan = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [backScan setImage:[UIImage imageNamed:@"icon_black_scancode"] forState:UIControlStateNormal];
    backScan.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [backScan setTitle:@"扫一扫" forState:UIControlStateNormal];
    backScan.titleLabel.font = [UIFont systemFontOfSize:10];
    [backScan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backScan setTitleEdgeInsets:UIEdgeInsetsMake(backScan.imageView.frame.size.height    , -53, 0, 0)];
    [backScan setImageEdgeInsets:UIEdgeInsetsMake(0, 0, backScan.titleLabel.frame.size.height, 0)];
    [backScan addTarget:self action:@selector(clickBackScan) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backScan];
    
}

-(void)clickBackScan{
    [self.navigationController pushViewController:[BQScanViewController new] animated:YES];
}

#pragma mark - 导航栏配送选择按钮
-(void)setupDeliveryItem {
    
    self.deliveryTitleView = [[[NSBundle mainBundle] loadNibNamed:@"BQDeliveryTitleView" owner:nil options:nil]lastObject];
    self.deliveryTitleView.center = self.navigationItem.titleView.center;
    self.navigationItem.titleView = self.deliveryTitleView;
    
    self.deliveryTitleView.backgroundColor = kMainColor;
 
    [self.deliveryTitleView.deliveryButton addTarget:self action:@selector(fillAddressInfo) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)fillAddressInfo{
    BQSelAddressViewController *addSelVC = [BQSelAddressViewController new];
    WEAKSELF
    addSelVC.modifyDeliveryAddressBlock = ^(NSString *address) {
        [weakSelf.deliveryTitleView.deliveryButton setTitle:address forState:UIControlStateNormal];
    };
    
    [self.navigationController pushViewController:addSelVC animated:YES];
}

#pragma mark - 导航栏搜索按钮
-(void)setupSearchItem{
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [searchBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -50);
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(searchBtn.imageView.frame.size.height , -40, 0, 0)];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, searchBtn.titleLabel.frame.size.height, 0)];
    [searchBtn addTarget:self action:@selector(clickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
}
-(void)clickSearchBtn{
    [self.navigationController pushViewController:[BQSearchViewController new] animated:YES];
}







@end
