//
//  BQSuperMarketViewController.m
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQSuperMarketViewController.h"

#import "BQGoodsInfoModes.h"
#import "BQCategroy.h"
#import <Masonry.h>
#import "BQProduct.h"
#import <SVProgressHUD.h>

#import "BQCategoryCell.h"
#import "BQGoodsInfoCell.h"
#import "BQTabBarController.h"
#import "BQDetailViewController.h"
#import "UIScrollView+SpiralPullToRefresh.h"

#import "BQNetWorkTools.h"

NSString *categoryCellID = @"categoryCellID";
NSString *productCellID = @"productCellID";

@interface BQSuperMarketViewController ()<  UITableViewDelegate,
                                            UITableViewDataSource,
                                            CAAnimationDelegate>
@property(nonatomic,weak)UITableView *categroysView ;

@property(nonatomic,weak)UITableView *productsView;

//categroy 数据
@property(nonatomic,strong)NSArray<BQCategroy *> *categroyInfoArr;

@property(nonatomic,assign)BOOL isLeft;

//下拉刷新的定时器
@property (nonatomic,strong)NSTimer *workTimer;

@end

@implementation BQSuperMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载数据
    [self loadData];
    
    //搭建UI
    [self setUpUI];
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self registerNotification];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self tearDownNotification];
    
    [SVProgressHUD dismiss];
}

#pragma mark -
#pragma mark 注册通知
- (void)registerNotification {
    
    //商品数量增加
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCountIncreaseNotification:) name:ProductCountIncreaseNotification object:nil];
    
    //商品数量减少
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCountReduceNotification:) name:ProductCountReduceNotification object:nil];
}


- (void)tearDownNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    
    [self tearDownNotification];
}

#pragma mark -
#pragma mark 通知处理
- (void)productCountIncreaseNotification:(NSNotification *)notification {
    
    //获得当前点击的cell
    BQGoodsInfoCell *cell = (BQGoodsInfoCell *)notification.object;
    
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
    BQGoodsInfoCell *cell = (BQGoodsInfoCell *)notification.object;
    
    //获取到减少的商品
    BQProduct *product = cell.productModel;
    
    [_ShoppingCar removeProduct:product];
}

#pragma mark -
#pragma mark 加入购物车动画
- (void)startAnimationWithCell:(BQGoodsInfoCell *)cell {
    
    //添加购物车动画
    UIImageView *productImgView = cell.productImgView;
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

#pragma mark -
#pragma mark 加载数据
- (void)loadData {
    
    
    //NSString *urlString = @"http://iosapi.itcast.cn/loveBeen/help.json.php";
    
    
    
    WEAKSELF
    [[BQGoodsInfoModes alloc] getCategeroyInfoCompleteBlock:^(NSArray<BQCategroy *> *categroyRes) {
        [SVProgressHUD dismiss];
        
        _categroyInfoArr = categroyRes;
        
        [weakSelf.categroysView reloadData];
        [weakSelf.productsView reloadData];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark -
#pragma mark 搭建界面
-(void)setUpUI{
    
    UITableView *categroysView = [[UITableView alloc]init];
    [self.view addSubview:categroysView];
    _categroysView = categroysView;
    self.categroysView.dataSource = self;
    self.categroysView.delegate = self;
    
    self.categroysView.showsVerticalScrollIndicator = NO;
    
    [categroysView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view).multipliedBy(0.25);
    }];
    
    [self.categroysView registerClass:[BQCategoryCell class] forCellReuseIdentifier:categoryCellID];
    
    UITableView *productsView = [[UITableView alloc]init];
    [self.view addSubview:productsView];
    _productsView = productsView;
    self.productsView.dataSource = self;
    self.productsView.delegate = self;
    
    self.productsView.estimatedRowHeight = 100;
    self.productsView.rowHeight = 100;
    
    [productsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view).multipliedBy(0.75);
    }];
    
    productsView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarH, 0);
    [self setTabViewRefresh];
    //添加表尾
    UIView *footerView = [UIView new];
    UIImage *image = [UIImage imageNamed:@"v2_common_footer"];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
    [imgView sizeToFit];
    [footerView addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
    }];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, image.size.height);
    productsView.tableFooterView = footerView;
    
    [self.productsView registerNib:[UINib nibWithNibName:@"BQGoodsInfoCell" bundle:nil] forCellReuseIdentifier:productCellID];
}

#pragma mark - tableview的下拉刷新控件的相关设置
- (void)setTabViewRefresh{
    
    __typeof (&*self) __weak weakSelf = self;

    [self.productsView addPullToRefreshWithActionHandler:^{
        
        [weakSelf refreshTriggered];
        
    }];
    self.productsView.pullToRefreshController.waitingAnimation = SpiralPullToRefreshWaitAnimationCircular;
    
}
- (void)refreshTriggered {
    
    [self.workTimer invalidate];
    
    self.workTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onAllworkDoneTimer) userInfo:nil repeats:NO];

}
- (void)onAllworkDoneTimer {
    [self.workTimer invalidate];
    self.workTimer = nil;
    
    
    [self.productsView.pullToRefreshController didFinishRefresh];
    [self.productsView reloadData];
}

#pragma mark --
#pragma mark -<UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.categroysView) {
        return 1;
    } else {
        return self.categroyInfoArr.count;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == self.categroysView) {
        return self.categroyInfoArr.count;
    } else {
        return self.categroyInfoArr[section].productArr.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.categroysView) {
        BQCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCellID forIndexPath:indexPath];
        cell.textLabel.text = self.categroyInfoArr[indexPath.row].name;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
         return cell;
    }
    else{
        BQGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:productCellID forIndexPath:indexPath];

         BQProduct *proModel = self.categroyInfoArr[indexPath.section].productArr[indexPath.row];
        cell.productModel = proModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark --
#pragma mark -<UITableViewDelegate>
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.productsView) {
        
        UILabel *lable = [UILabel new];
        [self.view addSubview:lable];
        lable.font = [UIFont systemFontOfSize:14];
        lable.text = [NSString stringWithFormat:@"    %@",self.categroyInfoArr[section].name];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.frame = CGRectMake(0, 0, 0, 40);
        lable.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
        return lable;
    }
 
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.productsView) {
        return 30;
    } else {
        return 0;
    }
}

#pragma mark --
#pragma mark -点击左边,右边联动
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.categroysView ) {
        _isLeft = YES;
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        [self.productsView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else{
        
        BQDetailViewController *targetVC = [[BQDetailViewController alloc]init];
        targetVC.model = self.categroyInfoArr[indexPath.section].productArr[indexPath.row];
        [self.navigationController pushViewController:targetVC animated:YES];
        
        
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.productsView) {
        if (! _isLeft) {
        
            NSArray *indexPathArr = [tableView indexPathsForVisibleRows];
            
            NSIndexPath *selectedPath = [indexPathArr lastObject];
            
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:selectedPath.section inSection:0];
            [self.categroysView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.productsView) {
        _isLeft = NO;
    }
}











@end
