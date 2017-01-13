//
//  BQShopController.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQShopController.h"
#import "BQShopView.h"
@interface BQShopController ()

@property(nonatomic,strong) BQShopView *shopView;

@end

@implementation BQShopController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     self.title = @"我的店铺";
    
    // 左上角返回按钮
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v2_goback"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItem = item;
    
    
    BQShopView *shopView = [BQShopView loadshopView];
    
    shopView.frame = self.view.bounds;
    
    self.shopView = shopView;
    
    [self.view addSubview:shopView];

}



@end
