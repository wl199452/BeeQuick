//
//  BQJumpToViewController.m
//  BeeQuick
//
//  Created by 风不会停息 on 2016/12/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQJumpToViewController.h"
#import <SVProgressHUD.h>

@interface BQJumpToViewController ()<UIWebViewDelegate>

@property (nonatomic,weak)UIWebView *webView;

@property(retain,nonatomic) UIProgressView * pView;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation BQJumpToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
    
}


- (void)setUI{
    [self setWebView];
    [self setBackBtn];
    [self setNav];
    [self setProgressBar];
}

- (void)setProgressBar{
    
    _pView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    _pView.progressTintColor = [UIColor orangeColor];
    _pView.trackTintColor = [UIColor grayColor];
    
    _pView.progress = 0.0;
    _pView.progressViewStyle=UIProgressViewStyleDefault;
    
    [self.view addSubview:_pView];
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];

}

- (void)setNav{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""]forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.title = @"BeeQuick";
    
}
- (void)setBackBtn{
    
    UIBarButtonItem *itemBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"v2_goback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    [itemBtn setTitle:@"sadas"];
    
    self.navigationItem.leftBarButtonItem = itemBtn;
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadWebWithURL:(NSURL *)url{
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    [self.webView loadRequest:request];
    
}

- (void)setWebView{
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _webView = web;
    web.delegate = self;
    
    [self.view addSubview:web];
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onAllworkDoneTimer) userInfo:nil repeats:YES];
    [SVProgressHUD showWithStatus:@"loading...👽"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [SVProgressHUD dismiss];
    [self.timer invalidate];
    [_pView removeFromSuperview];
    
}
- (void)onAllworkDoneTimer{
    
    _pView.progress += 0.05;

    
}
- (void)viewDidDisappear:(BOOL)animated{
    
    [SVProgressHUD dismiss];
}
@end
