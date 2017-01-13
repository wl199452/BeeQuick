//
//  BQTabBarController.m
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQTabBarController.h"
#import "BQNavigationController.h"
#import "BQShoppingCarViewController.h"

@interface BQTabBarController ()
@property (nonatomic, strong) NSObject *obj;
@property (nonatomic, strong) UITabBarItem *shoppingCarTabBarItem;
//@property (nonatomic, strong) UILabel *badgeLabel;
//@property (nonatomic, strong) UIImageView *imgV;
@end

@implementation BQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray* arrayVC = [NSMutableArray array];
    
    [arrayVC addObject:[self controllerWithTitle:@"首页" imageName:@"v2_home" className:@"BQHomeViewController" tag: 0]];
    [arrayVC addObject:[self controllerWithTitle:@"闪电超市" imageName:@"v2_order" className:@"BQSuperMarketViewController" tag: 1]];
    [arrayVC addObject:[self controllerWithTitle:@"购物车" imageName:@"shopCart" className:@"BQShoppingCarViewController" tag: 2]];
    [arrayVC addObject:[self controllerWithTitle:@"我的" imageName:@"v2_my" className:@"BQProfileViewController" tag: 3]];
    
    self.viewControllers = arrayVC.copy;
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shoppingCarTotalCountChangedNotification:) name:ShoppingCarTotalCountChangedNotification object:nil];
    
    
    NSInteger index = 0;
    for (UIView *sub in self.tabBar.subviews) {
        
        if ([sub isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            if (index == 2) {
                
                for (UIView *subview in sub.subviews) {
                    
                    if ([subview isKindOfClass:NSClassFromString(@"_UIBadgeView")]) {
                        self.obj = subview;
                        subview.hidden = YES;
                        
//                        for (UIView *tempView in subview.subviews) {
//                            CGRect frame;
//                            if ([tempView isKindOfClass:NSClassFromString(@"UIImageView")]) {
//                                frame = tempView.frame;
//                                [tempView removeFromSuperview];
//                            }
//                            
//                            UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reddot"]];
//                            imgV.frame = frame;
//                            [subview addSubview:imgV];
//                            
//                        }
                        
                    }
                }
            }
            index ++;
        }
    }
}

#pragma mark -
#pragma mark 处理通知
- (void)shoppingCarTotalCountChangedNotification:(NSNotification *)notification {
    
    NSInteger totalCount = [notification.userInfo[kShoppingCarTotalCount] integerValue];
    
    [self setBadgeValueWithTotalCount:totalCount];
}


- (UIViewController* )controllerWithTitle:(NSString*)title imageName:(NSString*)imageName className:(NSString*)className tag:(NSInteger)tag {
    
    Class clz = NSClassFromString(className);
    
    UIViewController* controller = [[clz alloc] init];
    
    controller.title = title;
    controller.tabBarItem.tag = tag;
    
    [controller.tabBarItem setImage:[UIImage imageNamed:imageName]];
    [controller.tabBarItem setSelectedImage:[[UIImage imageNamed:[imageName stringByAppendingString:@"_r"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : kMainColor} forState:UIControlStateSelected];
    [controller.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    
    if (tag == 2) {
        controller.tabBarItem.badgeColor = [UIColor redColor];
        [controller.tabBarItem setBadgeTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
        controller.tabBarItem.badgeValue = @"0";
        self.shoppingCarTabBarItem = controller.tabBarItem;
    }
    
    BQNavigationController* navigationVC = [[BQNavigationController alloc]initWithRootViewController:controller];
    
    return navigationVC;
}

/** 设置badge */
- (void)setBadgeValueWithTotalCount:(NSInteger)totalCount {
    
    UIView *view = (UIView *)self.obj;

    if (totalCount < 0) {
        return;
    }
    view.hidden = !totalCount;
    
    [self.shoppingCarTabBarItem setBadgeValue:[NSString stringWithFormat:@"%zd",totalCount]];
    
    view.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:6 options:0 animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

- (CGPoint)shoppingCarCenter {
    
    CGFloat x = (SCREEN_WIDTH / 8) * 5;
    CGFloat y = self.tabBar.center.y;
    return CGPointMake(x, y);
}

/** 点击tabBar的动画 */
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSInteger index = 0;
    for (UIView *sub in tabBar.subviews) {
        
        if ([sub isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            if (index == item.tag) {
                
                for (UIView* subview in sub.subviews) {
                    
                    if ([subview isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                        
                        subview.transform = CGAffineTransformMakeScale(0.5, 0.5);
                        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:6 options:0 animations:^{
                            subview.transform = CGAffineTransformIdentity;
                        } completion:nil];
                        
                    }
                }
                return;
            }
            index ++;
        }
    }
}



@end
