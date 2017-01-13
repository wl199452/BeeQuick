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
    
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(46);
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
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
}
//返回
-(void)clickGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
-(void)sheard{
    
}


@end
