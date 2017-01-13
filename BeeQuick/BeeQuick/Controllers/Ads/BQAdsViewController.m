//
//  BQAdsViewController.m
//  BeeQuick
//
//  Created by Mac on 16/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQAdsViewController.h"

@interface BQAdsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *adsImageView;

@property (weak, nonatomic) IBOutlet UILabel *adsDurationLabel;

@property (nonatomic, strong) NSTimer *timer;

/** 广告持续时间 */
@property (nonatomic, assign) NSInteger duration;

@end

@implementation BQAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.duration = 2;
}

- (void)setImagePath:(NSString *)imagePath {
    
    _imagePath = imagePath;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.adsImageView.image = [UIImage imageWithContentsOfFile:_imagePath];
    
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(changeLabelText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)changeLabelText {
    
    self.adsDurationLabel.text = [NSString stringWithFormat:@"%zds",self.duration];
    
    if (!self.duration) {
//        [UIView animateWithDuration:1.5 animations:^{
//            // 设置放大动画
//            self.view.transform = CGAffineTransformMakeScale(3, 3);
//            
//            // 设置透明度
//            self.view.alpha = 0;
//            
//        } completion:^(BOOL finished) {
//            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE" object:nil];
//        }];
    }
    self.duration -= 1;
}

@end
