//
//  BQUseRegularController.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQUseRegularController.h"

@interface BQUseRegularController ()

@end

@implementation BQUseRegularController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"使用规则";
    
    [self setNav];
    
    [self useRegular];

}

- (void)setNav
{
    // 左上角返回按钮
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v2_goback"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItem = leftitem;
}

#pragma mark
#pragma mark - 网页
-(void)useRegular
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSURL *url = [NSURL URLWithString:@"http://www.beequick.cn/show/info?tag=qa"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    [webView loadRequest:request];
    
    
    [self.view addSubview:webView];
}


@end
