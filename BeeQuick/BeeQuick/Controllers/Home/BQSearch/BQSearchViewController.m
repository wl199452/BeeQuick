//
//  BQSearchViewController.m
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQSearchViewController.h"
#import "BQNetWorkTools.h"
#import <SVProgressHUD.h>
#import "BQProduct.h"
#import "BQHomeDetailCell.h"
#import "BQSearchResultView.h"
#import "BQShoppingCarButton.h"
#import "BQShoppingCarViewController.h"
#import  "BQHomeDetailCellView.h"
#import "BQDetailViewController.h"

@interface BQSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, CAAnimationDelegate>
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSArray <NSString *>*hotqueryArray;
@property(nonatomic,assign)CGFloat btnX;
@property(nonatomic,strong)NSMutableArray <NSString *>*arrBtnW;

@property(nonatomic,strong)UITableView *tableView;

//第三个cell 的数据
@property(nonatomic,strong)NSArray<BQProduct *> *detailsArray;

//分解的cell的左边View的数组集合
@property(nonatomic,strong)NSArray<BQProduct *> *rightArr;
//分解的cell的右边View的数组集合
@property(nonatomic,strong)NSArray<BQProduct *> *leftArr;

@property(nonatomic,weak)BQSearchResultView *headerView;

@property (nonatomic, strong) BQShoppingCarButton *shoppingCarButton;

@end

static NSString *ThirdCell = @"thirdCell";
@implementation BQSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchBar];
    [self setGoBackButton];
    [self setupSearchBtnViews];
    
    
}
#pragma mark -
#pragma mark 生命周期

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self registerNotification];
    
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    
    [keyWin addSubview:self.shoppingCarButton];
    
    self.shoppingCarButton.productCount = _ShoppingCar.totalCount;
    
    [self.shoppingCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(keyWin).offset(-20);
        make.bottom.equalTo(keyWin).offset(-40);
        make.width.height.mas_equalTo(60);
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
    
    [self.shoppingCarButton removeFromSuperview];
    
    [self tearDownNotification];
}

#pragma mark -
#pragma mark 通知相关

- (void)registerNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickCell:) name:BeeQuickClickCellJumpNotifacation object:nil];

    //商品数量增加
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCountIncreaseNotification:) name:ProductCountIncreaseNotification object:nil];
    
    //商品数量减少
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCountReduceNotification:) name:ProductCountReduceNotification object:nil];
}

- (void)tearDownNotification {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)dealloc {
    [self tearDownNotification];
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


-(void)clickCell:(NSNotification *)noti{

    BQHomeDetailCellView *detailCellView = noti.userInfo[kCellView];
    
    BQDetailViewController *targetVC = [[BQDetailViewController alloc]init];
    targetVC.model = detailCellView.productModel;
    [self.navigationController pushViewController:targetVC animated:YES];
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
    
    CGPoint endPoint = self.shoppingCarButton.center;
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
#pragma mark setupShoppingCarButton

-(BQShoppingCarButton *)shoppingCarButton {
    
    if (!_shoppingCarButton) {
        self.shoppingCarButton = [BQShoppingCarButton shoppingCarButton];
        
        WEAKSELF
        self.shoppingCarButton.showshoppingCarBlock = ^() {
            
            BQShoppingCarViewController *shoppingCarVC = [BQShoppingCarViewController new];
            UINavigationController* navigationVC = [[UINavigationController alloc]initWithRootViewController:shoppingCarVC];
            [weakSelf presentViewController:navigationVC animated:YES completion:nil];
        };
        
        self.shoppingCarButton.hidden = YES;
    }
    return _shoppingCarButton;
}

#pragma mark - SearchBtnViews
-(void)setupSearchBtnViews{
    
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
    UILabel *hotqueryLbl = [[UILabel alloc]init];
    hotqueryLbl.text = @"热门搜索";
    [hotqueryLbl setTextColor:[UIColor grayColor]];
    hotqueryLbl.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:hotqueryLbl];
    [hotqueryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(SCREEN_WIDTH/30.0);
        make.top.equalTo(self.view).offset(SCREEN_WIDTH/30.0);
    }];
    
    NSDictionary *parameters = @{@"call":@(6)};
    [[BQNetWorkTools sharedTools] requestWithMethodType:POST urlString:@"http://iosapi.itcast.cn/loveBeen/search.json.php" parameters:parameters finishedCallBackBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error != nil) {
            NSLog(@"出错啦😯%@",error);
            return ;
        }
        NSDictionary *arrayDict = responseObject[@"data"];
        
        NSArray *arrayHotquery = arrayDict[@"hotquery"];
        self.hotqueryArray = arrayHotquery;
        
        
        //按钮布局
        float marginX = SCREEN_WIDTH / 40.0;
        float marginY = SCREEN_HEIGHT / 18.0;
        
        float originalY = SCREEN_HEIGHT / 13.0;
        
        float BtnH = SCREEN_WIDTH / 14.0;//按钮高度
        float BtnW ;
        
        for (int i = 0; i < self.hotqueryArray.count; i++) {
            UIButton *btn = [UIButton new];
            btn.tag = i;
            [btn addTarget:self action:@selector(getSearchResult:) forControlEvents:UIControlEventTouchUpInside];
            if (self.hotqueryArray[i].length == 1) {
                BtnW = self.hotqueryArray[i].length * (SCREEN_WIDTH / 12.0);
            }else{
                BtnW = self.hotqueryArray[i].length * (SCREEN_WIDTH / 18.0);
            }
            
            int row = i / 5;
            
            if (i == 0 || i == 5 || i == 10) {
                [btn setFrame:CGRectMake(marginX * 2, originalY + row * marginY, BtnW, BtnH)];
                [self.view addSubview:btn];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
                [btn setTitle:self.hotqueryArray[i] forState:UIControlStateNormal];
                _btnX = btn.frame.origin.x;
            }else{
                if (self.hotqueryArray[i-1].length == 1) {
                    _btnX = _btnX + self.hotqueryArray[i-1].length * (SCREEN_WIDTH / 12.0) + marginX;
                }else{
                    _btnX = _btnX + self.hotqueryArray[i-1].length * (SCREEN_WIDTH / 18.0) + marginX;
                }
                
                [btn setFrame:CGRectMake(_btnX , originalY + row * marginY, BtnW, BtnH)];
                [self.view addSubview:btn];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
                [btn setTitle:self.hotqueryArray[i] forState:UIControlStateNormal];
            }
        }
        
        
    }];
    
}
#pragma mark - getSearchResult
-(void)getSearchResult:(UIButton *)button{
    self.searchBar.text = self.hotqueryArray[button.tag];
    
    [self setTabViewUI];
    
    self.headerView.searchInfo = self.searchBar.text;
    
    [self.searchBar resignFirstResponder];
}

-(void)setTabViewUI{
    
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[BQHomeDetailCell class] forCellReuseIdentifier:ThirdCell];
    [self setupTableViewheaderView];
    
    [SVProgressHUD showWithStatus:@"正在为您搜索,请稍等>>>"];
    
    NSDictionary *parameters = @{@"call":@(8)};
    [[BQNetWorkTools sharedTools] requestWithMethodType:POST urlString:@"http://iosapi.itcast.cn/loveBeen/promotion.json.php" parameters:parameters finishedCallBackBlock:^(id responseObject, NSError *error) {
        if (error != nil) {
            [SVProgressHUD showErrorWithStatus:@"网络加载出现问题,请检查您的网络"];
            return ;
        }
        
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *dict in array) {
            BQProduct *detailModel  = [BQProduct yy_modelWithDictionary:dict];
            
            [arrM addObject:detailModel];
        }
        _detailsArray = arrM;
        NSMutableArray *arrM1 = [NSMutableArray array];
        NSMutableArray *arrM2 = [NSMutableArray array];
        for (int i = 0; i <_detailsArray.count ; i++) {
            if (i%2 == 1) {
                [arrM1 addObject:_detailsArray[i]];
            } else {
                [arrM2 addObject:_detailsArray[i]];
            }
        }
        
        self.leftArr = arrM2;
        self.rightArr = arrM1;
        
        [self.tableView reloadData];
        self.shoppingCarButton.hidden = NO;
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}

#pragma mark --
#pragma mark -  <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.detailsArray.count / 2  + self.detailsArray.count % 2;
}

#pragma mark - 设置行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 280;
    
}
#pragma mark --
#pragma mark - 设置表头
-(void)setupTableViewheaderView{
    
    BQSearchResultView *headerView = [BQSearchResultView searchResultView];
    _headerView = headerView;
    [self.view addSubview:headerView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(80);
        make.trailing.top.leading.equalTo(self.tableView);
    }];
    
    self.tableView.tableHeaderView = headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BQHomeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ThirdCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.leftModel = self.leftArr[indexPath.row];
    cell.rightModel = self.rightArr[indexPath.row];
    
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    return cell;
    
}

#pragma mark --
#pragma mark - -   <UISearchBarDelegate>

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchBar.text.length == 0) {
        [self.tableView removeFromSuperview];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self setTabViewUI];
    self.headerView.searchInfo = searchBar.text;
    
    [self.searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}



#pragma mark - UISearchBar
-(void)setupSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavigationBarH)];
    searchBar.placeholder = @"请输入商品名称";
    self.searchBar = searchBar;
    self.searchBar.delegate = self;
    
    self.searchBar.returnKeyType = UIReturnKeyNext;
    // 把默认灰色背景浮层给去掉
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.backgroundImage = [UIImage new];
    
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = searchBar;
}



#pragma mark - 封装返回按钮的方法
-(void)setGoBackButton{
    UIButton *gobackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,20 , 40)];
    gobackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [gobackBtn setImage:[UIImage imageNamed:@"v2_goback"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:gobackBtn];
    [gobackBtn addTarget:self action:@selector(clickGoBackBtn) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickGoBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
