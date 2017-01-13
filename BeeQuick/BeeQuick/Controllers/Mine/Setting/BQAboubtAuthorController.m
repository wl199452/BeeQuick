//
//  BQAboubtAuthorViewController.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQAboubtAuthorController.h"

@interface BQAboubtAuthorController ()

@end

@implementation BQAboubtAuthorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于作者";
    
    [self setNav];
    
    [self aboutAuthor];
}

#pragma mark 
#pragma mark - 左上角按钮
- (void)setNav
{
    // 左上角返回按钮
    UIBarButtonItem* leftitem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v2_goback"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItem = leftitem;
}

#pragma mark
#pragma mark - 网页
-(void)aboutAuthor
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    [webView loadRequest:request];
    
    
    [self.view addSubview:webView];
}


@end
