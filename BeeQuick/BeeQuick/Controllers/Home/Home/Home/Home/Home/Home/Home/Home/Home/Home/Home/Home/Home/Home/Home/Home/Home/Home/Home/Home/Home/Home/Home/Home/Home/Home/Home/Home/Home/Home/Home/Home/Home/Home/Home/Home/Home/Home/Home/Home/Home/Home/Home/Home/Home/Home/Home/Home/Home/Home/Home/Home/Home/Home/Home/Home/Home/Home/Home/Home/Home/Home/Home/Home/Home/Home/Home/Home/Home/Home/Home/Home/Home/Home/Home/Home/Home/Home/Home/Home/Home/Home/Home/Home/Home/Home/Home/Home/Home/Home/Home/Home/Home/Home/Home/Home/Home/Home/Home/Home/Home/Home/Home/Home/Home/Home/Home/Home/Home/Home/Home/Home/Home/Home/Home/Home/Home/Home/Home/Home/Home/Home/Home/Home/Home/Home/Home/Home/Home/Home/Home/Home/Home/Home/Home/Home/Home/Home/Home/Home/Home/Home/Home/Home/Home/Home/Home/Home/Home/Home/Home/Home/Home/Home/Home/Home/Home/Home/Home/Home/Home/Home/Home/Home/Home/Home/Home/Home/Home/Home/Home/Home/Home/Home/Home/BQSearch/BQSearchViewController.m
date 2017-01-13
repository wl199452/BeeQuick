//
//  BQSearchViewController.m
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQSearchViewController.h"
#import "BQSearchView.h"
@interface BQSearchViewController ()
@property(nonatomic,weak)UIScrollView *scrollView;
@end

@implementation BQSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackItem];
    UIScrollView *scrollView = [UIScrollView new];
    _scrollView = scrollView;
    BQSearchView *searchBtnViews = [[[NSBundle mainBundle] loadNibNamed:@"BQSearchButtons" owner:nil options:nil]lastObject];
    [searchBtnViews.collectionBtn addTarget:self action:@selector(goSearch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:searchBtnViews];

    self.view = scrollView;
}

#pragma mark - 点击了热门搜索
-(void)goSearch{
    NSLog(@"点击了热门搜索");
}
#pragma mark - 设置返回按钮
-(void)setupBackItem{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavigationBarH)];
    searchBar.placeholder = @"请输入商品名称";
    self.navigationItem.titleView = searchBar;
    UIButton *goBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,20 , 40)];
    goBack.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [goBack setImage:[UIImage imageNamed:@"v2_goback"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:goBack];
    self.navigationItem.backBarButtonItem.image = [UIImage imageNamed:@"v2_goback"];
    [goBack addTarget:self action:@selector(clickGoBack) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
