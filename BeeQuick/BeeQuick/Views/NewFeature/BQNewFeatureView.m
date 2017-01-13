//
//  BQNewFeatureView.m
//  BeeQuick
//
//  Created by 风不会停息 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQNewFeatureView.h"
#define IMAGECOUNT 4

@interface BQNewFeatureView ()<UIScrollViewDelegate>


@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation BQNewFeatureView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        self.backgroundColor = kClearColor;
    }
    
    return self;
}

- (void)setUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    scrollView.backgroundColor = kClearColor;
    
    //添加图片
    // 循环创建图片框
    for (int i = 1; i <= IMAGECOUNT; i++) {
        // 拼接图片名称
        NSString *imageName = [NSString stringWithFormat:@"guide_40_%d",i];
        
        // 创建图片对象
        UIImage *image = [UIImage imageNamed:imageName];
        
        // 创建图片框
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * (i - 1), 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        // 设置图片
        imageView.image = image;
        // 设置图片框可交互
        imageView.userInteractionEnabled = YES;
        
        // 添加到scrollView 里面
        [scrollView addSubview:imageView];
        
        if (i==4) {
            
            // 设置更多按钮的宽度和高度
            CGFloat moreWidht = 80;
            CGFloat moreHeight = 40;
            // 创建“更多”按钮
            UIButton *moreButton = [UIButton buttonWithType:0];
            moreButton.bounds = CGRectMake(0, 0, moreWidht, moreHeight);
            // 设置‘更多’按钮的图片
            [moreButton setBackgroundImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];

            
            // 添加“更多”按钮点击事件的监听方法
            [moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [imageView addSubview:moreButton];
            
            // 设置“更多”按钮的自动布局约束
            
            [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imageView);
                make.bottom.equalTo(self).offset(-90);
            }];
        }
        
    
    
    scrollView.delegate = self;
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*IMAGECOUNT, SCREEN_HEIGHT);
    
//    scrollView.backgroundColor = [UIColor orangeColor];
    
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:scrollView];
    
    
}
    // 添加UIPageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    // 设置分页控件总页数
    pageControl.numberOfPages = IMAGECOUNT;
    pageControl.currentPage = 0;
    
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    [self addSubview:pageControl];
    _pageControl = pageControl;
    
    // 设置pageControl的约束
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-35);
        make.height.equalTo(@30);
    }];
}
#pragma mark -<UIScrollViewDelegate>

// 停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    //    NSLog(@"%d",index);
    if (index == IMAGECOUNT) {
        [scrollView removeFromSuperview];
        [self.pageControl removeFromSuperview];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE" object:nil];

    }
}
    
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 三个重要的数学函数
    //    ceil(<#double#>):取最大的整数 1.1 -> 2  |  1.6 -> 2
    //    round(<#double#>):四舍五入 1.3 -> 1 | 1.8 -> 2
    //    floor(<#double#>):去最小的整数 1.1 -> 1  |  1.9 -> 1
    
    // 计算当前页码
    int index =  round(scrollView.contentOffset.x / SCREEN_WIDTH) ;
    
    //    NSLog(@"%d",index);
    
    // 设置当前页码
    _pageControl.currentPage = index;
    
    
    if (index == IMAGECOUNT - 1) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE" object:nil];
    };
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    int index =  round(scrollView.contentOffset.x / SCREEN_WIDTH) ;
    
    //    NSLog(@"%d",index);
    
    // 设置当前页码
    _pageControl.currentPage = index;
    
    if (index == IMAGECOUNT) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE" object:nil];

    }
}
#pragma mark - 更多按钮点击事件的处理
/// 更多按钮的点击事件的监听方法
- (void)clickMoreButton:(UIButton *)button{
    // 以动画的方式，放大当前的图片框，设置当前图片框透明度为0
    // NSLog(@"%@",button.superview);
     [_pageControl removeFromSuperview];
   
    [UIView animateWithDuration:1.5 animations:^{
        UIImageView *imageView = (UIImageView *)button.superview;
       

        // 设置放大动画
        imageView.transform = CGAffineTransformMakeScale(3, 3);
        
        // 设置透明度
        imageView.alpha = 0;
        
        
    } completion:^(BOOL finished) {
//        [button.superview.superview removeFromSuperview];
         [self removeFromSuperview];
    
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE" object:nil];
        
    }];
}
@end
