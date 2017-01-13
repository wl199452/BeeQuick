//
//  BQSuggestController.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQSuggestController.h"
#import "BQSuggestView.h"
#import <SVProgressHUD.h>

@interface BQSuggestController ()

@property(nonatomic,strong) BQSuggestView *suggsetView;

@end

@implementation BQSuggestController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     self.title = @"意见反馈";
    
    [self setNav];
    
    BQSuggestView *suggsetView = [BQSuggestView loadsuggestView];
    
    suggsetView.frame = self.view.bounds;
    
     self.suggsetView = suggsetView;
    
    [self.view addSubview:suggsetView];
   
}

- (void)setNav
{
    // 左上角返回按钮  
    UIBarButtonItem* leftitem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v2_goback"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItem = leftitem;
    
   // 右上角返回按钮
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    // 设置右上角的返回按钮
    self.navigationItem.rightBarButtonItem = rightitem;
}

- (void)popViewController
{
    [SVProgressHUD showSuccessWithStatus:@"发送成功"];
}

@end
