//
//  BQDetailViewController.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQDetailViewController.h"
#import "BQProductDetailView.h"
#import "BQProductDetailFooterView.h"
#import <SVProgressHUD.h>
#import "BQShoppingCarViewController.h"


@interface BQDetailViewController ()

@property(nonatomic,weak) UIScrollView *scrollView;

@end

@implementation BQDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.model.name;
    
    [self setUpItem];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self registerNotification];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self tearDownNotification];
    
    [SVProgressHUD dismiss];
}

#pragma mark -
#pragma mark 注册通知
- (void)registerNotification {
    
    //商品数量增加
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCountIncreaseNotification:) name:ProductCountIncreaseNotification object:nil];
    
    //商品数量减少
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCountReduceNotification:) name:ProductCountReduceNotification object:nil];
}

- (void)tearDownNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark 通知处理
- (void)productCountIncreaseNotification:(NSNotification *)notification {
    
    //获得当前点击的cell
    BQProductDetailFooterView *footerView = (BQProductDetailFooterView *)notification.object;
    
    //获取到添加的商品
    BQProduct *product = footerView.product;
    
    //商品加到购物车
    if ([product.hasChoseCount integerValue] >= [product.number integerValue]) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@库存不足了\n先买这么多，过段时间再来看看吧",product.name]];
        return;
    }
    [_ShoppingCar addProduct:product];
}

- (void)productCountReduceNotification:(NSNotification *)notification {
    
    //获得当前点击的cell
    BQProductDetailFooterView *footerView = (BQProductDetailFooterView *)notification.object;
    
    //获取到减少的商品
    BQProduct *product = footerView.product;
    
    [_ShoppingCar removeProduct:product];
}


#pragma mark -
#pragma mark 设置UI

-(void)setupUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    self.scrollView.backgroundColor = [UIColor cyanColor];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.scrollView.bounces = NO;
    
    
    BQProductDetailView *contentView = [BQProductDetailView productDetailView];
    contentView.detailModel = self.model;
    
    [self.scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.mas_equalTo(2500);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    
    BQProductDetailFooterView *footerView = [BQProductDetailFooterView productDetailFooterView];
    footerView.product = self.model;
    WEAKSELF
    footerView.showshoppingCarBlock = ^() {
      
        BQShoppingCarViewController *shoppingCarVC = [BQShoppingCarViewController new];
        UINavigationController* navigationVC = [[UINavigationController alloc]initWithRootViewController:shoppingCarVC];
        [weakSelf presentViewController:navigationVC animated:YES completion:nil];
    };
    
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(69);
    }];
}

#pragma mark - 设置返回按钮
-(void)setUpItem{
    
    UIButton *goBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,20 , 40)];
    goBack.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [goBack setImage:[UIImage imageNamed:@"v2_goback"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:goBack];
    [goBack addTarget:self action:@selector(clickGoBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(sheard)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:0.5 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
}
//返回
-(void)clickGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
-(void)sheard{
    
}


@end
