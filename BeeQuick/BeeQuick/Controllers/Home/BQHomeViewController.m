//
//  BQHomeViewController.m
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//


#import "BQHomeViewController.h"
#import "BQNetWorkTools.h"
#import "BQHomeModel.h"
#import <SDCycleScrollView.h>
#import "BQHomeIconsCell.h"
#import "BQActivitiesCell.h"
#import "BQJumpToViewController.h"
#import "BQHomeJumpDelegate.h"

#import "BQHomeDetailCell.h"
#import "BQHomeDetailCellView.h"
#import "BQProduct.h"
#import "BQDetailViewController.h"
#import "BQHomeFooterView.h"

#import "BQTabBarController.h"
#import "UIScrollView+SpiralPullToRefresh.h"
#import <SVProgressHUD.h>
#import "BQDeliveryTitleView.h"

static NSString *IconsCell = @"IconsCell";
static NSString *ActivitiesCell = @"ActivitiesCell";
static NSString *testCell = @"cell";

static NSString *ThirdCell = @"thirdCell";

@interface BQHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,BQHomeJumpDelegate, CAAnimationDelegate>

@property (nonatomic,weak)UITableView *mainTableView;

@property (nonatomic,strong)BQHomeModel *homeModel;

//第三个cell 的数据
@property(nonatomic,strong)NSArray<BQProduct *> *detailsArray;

//分解的cell的左边View的数组集合
@property(nonatomic,strong)NSArray<BQProduct *> *leftArr;
//分解的cell的右边View的数组集合
@property(nonatomic,strong)NSArray<BQProduct *> *rightArr;

//下拉刷新的定时器
@property (nonatomic,strong)NSTimer *workTimer;

@end


@implementation BQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    
    [self setTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerNotification];
    
    self.navigationController.navigationBar.barTintColor = kMainColor;

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self tearDownNotification];
    
    [SVProgressHUD dismiss];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)getData{
    
    BQHomeModel *model = [BQHomeModel new];
    self.homeModel = model;
    
#pragma mark --
#pragma mark -对拿到的数据进行左右拆分
    [model  getDetailInfoWithCompleteBlock:^(NSArray<BQProduct *> *detailsArray) {
        if (detailsArray == nil) {
            return ;
        }
        _detailsArray = detailsArray;
        NSMutableArray *arrM1 = [NSMutableArray array];
        NSMutableArray *arrM2 = [NSMutableArray array];
        for (int i = 0; i <detailsArray.count ; i++) {
            if (i%2 == 1) {
                [arrM1 addObject:detailsArray[i]];
            }
            else{
                [arrM2 addObject:detailsArray[i]];
            }
        }
        
        self.leftArr = arrM2;
        self.rightArr = arrM1;
        
        [self.mainTableView reloadData];
        
    }];
}
- (void)registerNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:@"DOWNLOADCOMPLETE" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickCell:) name:BeeQuickClickCellJumpNotifacation object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickMoreInfo) name:HomeFooterViewClickMoreBtnNotifacation object:nil];
    
    //商品数量增加
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCountIncreaseNotification:) name:ProductCountIncreaseNotification object:nil];
    
    //商品数量减少
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCountReduceNotification:) name:ProductCountReduceNotification object:nil];
    
}

- (void)tearDownNotification {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)productCountIncreaseNotification:(NSNotification *)notification {
    
    //获得当前点击的cell
    BQHomeDetailCellView *cell = (BQHomeDetailCellView *)notification.object;
    
    //获取到添加的商品
    BQProduct *product = cell.productModel;
    
    //商品加到购物车
    if ([product.hasChoseCount integerValue] >= [product.number integerValue]) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@库存不足了\n先买这么多，过段时间再来看看吧",product.name]];
        return;
    }
    [_ShoppingCar addProduct:product];
    
    //开始 动画
    [self startAnimationWithCell:cell];
}

- (void)productCountReduceNotification:(NSNotification *)notification {
    
    //获得当前点击的cell
    BQHomeDetailCellView *cell = (BQHomeDetailCellView *)notification.object;
    
    //获取到减少的商品
    BQProduct *product = cell.productModel;
    
    [_ShoppingCar removeProduct:product];
}


#pragma mark -
#pragma mark 加入购物车动画
- (void)startAnimationWithCell:(BQHomeDetailCellView *)cell {
    
    //添加购物车动画
    UIImageView *productImgView = cell.imgView;
    CGPoint startPoint = [cell convertPoint:productImgView.center toView:[UIApplication sharedApplication].keyWindow];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:productImgView.image];
    imageView.bounds = productImgView.bounds;
    imageView.center = startPoint;
    
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
    
    BQTabBarController *tabBarVC = (BQTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    CGPoint endPoint = tabBarVC.shoppingCarCenter;
    CGPoint controlPoint = CGPointMake(startPoint.x, startPoint.y-200 );
    
    //关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAnimation setValue:imageView forKey:@"imageView"];
    
    //基本动画
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    baseAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    baseAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)];
    
    //BezierPath曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    keyAnimation.path = path.CGPath;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 0.8;
    groupAnimation.animations = @[keyAnimation, baseAnimation];
    groupAnimation.delegate = self;
    
    [imageView.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
}

//动画完成代理
- (void)animationDidStop:(CAAnimationGroup *)anim finished:(BOOL)flag {
    
    UIImageView *imageView = [anim.animations[0] valueForKey:@"imageView"];
    
    [imageView removeFromSuperview];
}



-(void)reloadTableView:(NSNotification *)noti{
    
    [self.mainTableView reloadData];
    [self setCycleScrollView];
    
}


-(void)clickMoreInfo{
    
    BQTabBarController *tabVC = (BQTabBarController *) self.navigationController.parentViewController;
    tabVC.selectedIndex = 1;
}

-(void)clickCell:(NSNotification *)noti{
    
    BQHomeDetailCellView *detailCellView = noti.userInfo[kCellView];
    
    BQDetailViewController *targetVC = [[BQDetailViewController alloc]init];
    targetVC.model = detailCellView.productModel;
    [self.navigationController pushViewController:targetVC animated:YES];
    
}

- (void) setTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.mainTableView = tableView;
    [self.view addSubview:tableView];
    
    //注册cell
    [tableView registerClass:[BQHomeIconsCell class] forCellReuseIdentifier:IconsCell];
    [tableView registerClass:[BQActivitiesCell class] forCellReuseIdentifier:ActivitiesCell];
    
    
    //下拉刷新
    [self setTabViewRefresh];
    
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    
#pragma mark --
#pragma mark - 第三个Cell
    [tableView registerClass:[BQHomeDetailCell class] forCellReuseIdentifier:ThirdCell];
    
    
}
#pragma mark - tableview的下拉刷新控件的相关设置
- (void)setTabViewRefresh{
    
    __typeof (&*self) __weak weakSelf = self;
    
    [self.mainTableView addPullToRefreshWithActionHandler:^{

        [weakSelf refreshTriggered];
        
    }];
    self.mainTableView.pullToRefreshController.backgroundColor = [UIColor whiteColor];
    self.mainTableView.pullToRefreshController.waitingAnimation = SpiralPullToRefreshWaitAnimationLinear;
    
}
- (void)refreshTriggered {

    [self.workTimer invalidate];
    
    self.workTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onAllworkDoneTimer) userInfo:nil repeats:NO];
}
- (void)onAllworkDoneTimer {
    [self.workTimer invalidate];
    self.workTimer = nil;
    
    [self.mainTableView.pullToRefreshController didFinishRefresh];
    [self.mainTableView reloadData];
}

//设置组间间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        return 120;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 0.1;
    }
    
    return 30;
}
-(void)setCycleScrollView{
    
    SDCycleScrollView *cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) imageURLStringsGroup:self.homeModel.focusImgURLs];
    [cycle setPlaceholderImage:[UIImage imageNamed:@"v2_placeholder_full_size"]];
    cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycle.currentPageDotColor = [UIColor orangeColor];
    self.mainTableView.tableHeaderView = cycle;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return self.detailsArray.count / 2  + self.detailsArray.count % 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (indexPath.section == 0) {
         BQHomeIconsCell *cell = [tableView dequeueReusableCellWithIdentifier:IconsCell forIndexPath:indexPath];
         cell.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
         if (self.homeModel.iconsArray != nil) {
             cell.model = self.homeModel;
             cell.delegate = self;
         }
         
         return cell;
     }
     
     if(indexPath.section == 1){
         
         BQActivitiesCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivitiesCell];
         cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
         if (self.homeModel.activitiesArray != nil) {
             cell.model = self.homeModel;
             cell.delegate = self;
             
         }
         return cell;
     }
#pragma mark --
#pragma mark -  第三个cell
    
    else{
        BQHomeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ThirdCell forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftModel = self.leftArr[indexPath.row];
        cell.rightModel = self.rightArr[indexPath.row];
        
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        return cell;
    }
    
}
#pragma mark - 设置行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 90;
    }
    if (indexPath.section == 1) {
        return 560;
    }
        return 280;

}
#pragma mark - 控制器跳转url
- (void)jumptoURL:(NSURL *)url{
    
    BQJumpToViewController *vc = [[BQJumpToViewController alloc]init];
    
    [vc loadWebWithURL:url];
    

    [self.navigationController pushViewController:vc animated:YES];
    
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
        headView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.view addSubview:headView];
        
        UILabel *lbl = [UILabel new];
        [headView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headView);
            make.leading.equalTo(headView).mas_offset(8);
        }];
        
        lbl.text = @"新鲜热卖";
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textColor = RGBCOLOR(132, 132, 132);
        
        return headView;
        
    }
    
    return nil;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        
        BQHomeFooterView *footerView = [BQHomeFooterView homeFooterView];
        footerView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.view addSubview:footerView];
        
        return footerView;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //设置cell 按照z轴旋转90度，注意是弧度
    if (indexPath.section == 2) {
        NSArray *array =  tableView.indexPathsForVisibleRows;
        NSIndexPath *firstIndexPath = array[1];
        
        //设置anchorPoint
        cell.layer.anchorPoint = CGPointMake(0, 0.5);
        //为了防止cell视图移动，重新把cell放回原来的位置
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
        
        if (firstIndexPath.row < indexPath.row+1  ) {
            cell.layer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1.0);
        }else{
            cell.layer.transform = CATransform3DMakeRotation(- M_PI_4, 0, 0, 1.0);
        }
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1.0;
    }];
}


- (void)dealloc{
    
    [self tearDownNotification];
}
@end
