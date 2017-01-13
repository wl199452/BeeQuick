//
//  AppDelegate.m
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "BQTabBarController.h"
#import "BQNavigationController.h"
#import "BQShoppingCarViewController.h"
#import "BQNetWorkTools.h"
#import <SDWebImage/SDWebImageManager.h>
#import "BQAdsViewController.h"
#import "NSString+Hash.h"
#import "BQNewFeatureView.h"
#import <UMSocialCore/UMSocialCore.h>


@interface AppDelegate ()<UITabBarControllerDelegate>

/** 广告业大图的URL */
@property (nonatomic, copy) NSString *bigImageString;

@property (nonatomic, strong) BQTabBarController *tabBarController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self regisiterNewFeatureNoti];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //创建TabBarController
    self.tabBarController = [[BQTabBarController alloc]init];
    self.tabBarController.delegate = self;
    
    //创建广告页控制器
    BQAdsViewController *adsVC = [[BQAdsViewController alloc]initWithNibName:@"BQAdsViewController" bundle:nil];
    
    NSString *versionKey = @"CFBundleVersion";
    
    //上一个版本编号，从沙盒存储的数据中获取
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    //获取当前版本的编号，从info.plist中获取
    NSString *currentVersion =[NSBundle mainBundle].infoDictionary[versionKey];
    
    //如果不显示新特性
    if ([lastVersion isEqualToString:currentVersion]) {
        
        NSString *fileName = [[NSUserDefaults standardUserDefaults] objectForKey:kPerferenceAdsImageKey];
        
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
        
        NSLog(@"%@",NSHomeDirectory());
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
            
            adsVC.imagePath = filePath;
            self.window.rootViewController = adsVC;
        } else {
            self.window.rootViewController = self.tabBarController;
        }
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        BQNewFeatureView *view = [[BQNewFeatureView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.tabBarController.view addSubview:view];
        self.window.rootViewController =self.tabBarController;
    }
    
    [self.window makeKeyAndVisible];
    
    [self performSelectorInBackground:@selector(downloadAdsInfo) withObject:nil];

    
    
#pragma mark --
#pragma mark -友盟分享
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey 友盟默认提供
    
    // 使用自己的AppKey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5861ccfe2ae85b11be0033ee"];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"100424468"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
    // 两种方案: 一种手动设置,一种友盟后台进行设置
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1060856073"  appSecret:@"d9e99657a3d25ae3dddae477a06e0cb4" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    return YES;
}


- (void)downloadAdsInfo {
    
    NSDictionary *parameters = @{@"call" : @"7"};
    
    WEAKSELF
    [[BQNetWorkTools sharedTools] requestWithMethodType:POST urlString:@"http://iosapi.itcast.cn/loveBeen/ad.json.php" parameters:parameters finishedCallBackBlock:^(id responseObject, NSError *error) {

        if (error || [responseObject[@"code"] integerValue]) {
            NSLog(@"下载广告信息出错。");
            return ;
        }
        
        weakSelf.bigImageString = responseObject[@"data"][@"img_big_name"];
        
        /** 计算出的MD5 */
        NSString *imageMD5String = [weakSelf.bigImageString md5String];
        
        /** 存储的MD5 */
        NSString *adsMD5String = [[NSUserDefaults standardUserDefaults] objectForKey:kPerferenceAdsImageKey];
        
        if (!adsMD5String || [imageMD5String isEqualToString:adsMD5String]) {
            //说明网址有变化，更新
            [[NSUserDefaults standardUserDefaults] setObject:imageMD5String forKey:kPerferenceAdsImageKey];
            
            //下载图片
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:weakSelf.bigImageString] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                NSData *imageData = UIImagePNGRepresentation(image);
                
                NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:imageMD5String];
                
                [imageData writeToFile:filePath atomically:YES];
            }];
        }
    }];
    
}


//拦截TabBarItem点击 购物车 按钮的事件，model出自定义的控制器
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    BQNavigationController *navController = (BQNavigationController *)viewController;
    if ([navController.visibleViewController  isMemberOfClass:NSClassFromString(@"BQShoppingCarViewController")]) {
        
        UIViewController* controller = [[BQShoppingCarViewController alloc] init];
        
        UINavigationController *navigationVC = [[UINavigationController alloc]initWithRootViewController:controller];
        //[self.window.rootViewController presentViewController:navController animated:YES completion:nil];
        [tabBarController presentViewController:navigationVC animated:YES completion:nil];
        return NO;
    }
    return YES;
}




- (void)regisiterNewFeatureNoti{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootVC) name:@"CHANGE" object:nil];
    
}

- (void)changeRootVC{
    
    self.window.rootViewController = self.tabBarController;
}



#pragma mark --
#pragma mark - 友盟   支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}













@end
