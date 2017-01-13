//
//  BQShoppingCarViewController.m
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQShoppingCarViewController.h"
#import "BQShoppingCarAddressCell.h"
#import "BQSuperMarketInfoCell.h"
#import "BQReceiveTimeCell.h"
#import "BQReceiveGoodsMarkCell.h"
#import "BQShoppingCarProductCell.h"
#import "BQShoppingCarStatisticsView.h"
#import "BQShoppingCarEmptyView.h"
#import "BQPaymentController.h"
#import <SVProgressHUD.h>
#import "BQProduct.h"
#import "BQDetailViewController.h"

@interface BQShoppingCarViewController ()<  UITableViewDelegate,
                                            UITableViewDataSource,
                                            BQShoppingCarProductCellDelegate,
                                            BQShoppingCarStatisticsViewDelegate,
                                            BQPaymentControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BQShoppingCarStatisticsView *statisticsView;

/** 当前操作的商品 */
@property (nonatomic, strong) BQProduct *currentProduct;

@end

static NSString *shoppingCarAddressCellID = @"shoppingCarAddressCellID";
static NSString *superMarketInfoCellID = @"superMarketInfoCellID";
static NSString *receiveTimeCellID = @"receiveTimeCellID";
static NSString *receiveGoodsMarkCellID = @"receiveGoodsMarkCellID";
static NSString *shoppingCarCellID = @"shoppingCarCellID";

@implementation BQShoppingCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";
    //self.currentProductArray = [NSMutableArray array];
    
    [self setupNavBar];
    
    NSInteger productCount = _ShoppingCar.totalCount;
    
    if (productCount == 0) {
        
        [self setupEmptyView];
        
        return;
    }
    
    [self setupTableView];
    
    [self setupStatisticsView];
    
//    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self registerNotification];
    [self.tableView reloadData];
    self.statisticsView.totalPrice = _ShoppingCar.commitPrice;

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
    
    //购物车商品总数的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shoppingCarTotalCountChangedNotification:) name:ShoppingCarTotalCountChangedNotification object:nil];
}

- (void)tearDownNotification {
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ProductCountIncreaseNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ProductCountReduceNotification object:nil];
}

- (void)dealloc {
    
    [self tearDownNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ShoppingCarTotalCountChangedNotification object:nil];
}

#pragma mark -
#pragma mark 通知处理
- (void)productCountIncreaseNotification:(NSNotification *)notification {
    
    //获得当前点击的cell
    BQShoppingCarProductCell *cell = (BQShoppingCarProductCell *)notification.object;
    
    //获取到添加的商品
    self.currentProduct = cell.product;
    
    //商品加到购物车
    if ([self.currentProduct.hasChoseCount integerValue] >= [self.currentProduct.number integerValue]) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@库存不足了\n先买这么多，过段时间再来看看吧",self.currentProduct.name]];
        return;
    }
    [_ShoppingCar addProduct:self.currentProduct];
    
    self.statisticsView.totalPrice = _ShoppingCar.commitPrice;
}

- (void)productCountReduceNotification:(NSNotification *)notification {
    
    //获得当前点击的cell
    BQShoppingCarProductCell *cell = (BQShoppingCarProductCell *)notification.object;
    
    //获取到减少的商品
    self.currentProduct = cell.product;
    
    if ([self.currentProduct.hasChoseCount integerValue] == 1) {
        
        [self showAlert];

    } else {
        [_ShoppingCar removeProduct:self.currentProduct];
        self.statisticsView.totalPrice = _ShoppingCar.commitPrice;
    }
}

- (void)shoppingCarTotalCountChangedNotification:(NSNotification *)notification {
    
    NSInteger totalCount = [notification.userInfo[kShoppingCarTotalCount] integerValue];
    
    if (totalCount == 0) {
        [self.tableView removeFromSuperview];
        [self setupEmptyView];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)showAlert {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除商品" message:@"确认删除此商品吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        NSInteger count = [self.currentProduct.hasChoseCount integerValue];
        
        for (int i = 0; i < count; i ++) {
            [_ShoppingCar removeProduct:self.currentProduct];
        }
        [self.tableView reloadData];
        self.statisticsView.totalPrice = _ShoppingCar.commitPrice;
    }
}


#pragma mark -
#pragma mark 设置UI
- (void)setupEmptyView {
    
    BQShoppingCarEmptyView *emptyView = [BQShoppingCarEmptyView shoppingCarEmptyView];
    
    WEAKSELF
    emptyView.goShopping = ^(){
        [weakSelf back];
    };
    
    [self.view addSubview:emptyView];
    emptyView.frame = SCREEN_BOUNDS;
}

- (void)setupNavBar {
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"v2_goback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    //下面这句可以去掉横线
    //[self.navigationController.navigationBar.layer setMasksToBounds:YES];
    //self.navigationItem.titleView = nil;
    //self.navigationItem.rightBarButtonItem = nil;
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:SCREEN_BOUNDS style:UITableViewStyleGrouped];
    self.tableView.frame = self.view.frame;
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarH+kNavigationBarH+kStatusBarH, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BQShoppingCarAddressCell" bundle:nil] forCellReuseIdentifier:shoppingCarAddressCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"BQSuperMarketInfoCell" bundle:nil] forCellReuseIdentifier:superMarketInfoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"BQReceiveTimeCell" bundle:nil] forCellReuseIdentifier:receiveTimeCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"BQReceiveGoodsMarkCell" bundle:nil] forCellReuseIdentifier:receiveGoodsMarkCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"BQShoppingCarProductCell" bundle:nil] forCellReuseIdentifier:shoppingCarCellID];
}

/** 添加购物车统计视图 */
- (void)setupStatisticsView {
    
    self.statisticsView = [BQShoppingCarStatisticsView ShoppingCarStatisticsView];
    [self.view addSubview:self.statisticsView];
    [self.statisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(kTabBarH);
    }];
    self.statisticsView.delegate = self;
    self.statisticsView.totalPrice = _ShoppingCar.commitPrice;
}

#pragma mark -
#pragma mark 内部函数

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 4) {
        return 1;
    }
    return _ShoppingCar.productInShoppingCar.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID;
    switch (indexPath.section) {
        case 0:
        {
            cellID = shoppingCarAddressCellID;
            BQShoppingCarAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 1:
        {
            cellID = superMarketInfoCellID;
            BQSuperMarketInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 2:
        {
            cellID = receiveTimeCellID;
            BQReceiveTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 3:
        {
            cellID = receiveGoodsMarkCellID;
            BQReceiveGoodsMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        default:
        {
            cellID = shoppingCarCellID;
            BQShoppingCarProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.product = _ShoppingCar.productInShoppingCar[indexPath.row];
            
            cell.delegate = self;
            return cell;
        }
    }
}


#pragma mark -
#pragma mark BQShoppingCarProductCellDelegate
/** 是否选择某一款商品 */
- (void)shoppingCarProductCell:(BQShoppingCarProductCell *)cell isChoseProductType:(BOOL)isChose {
    
    if (isChose) {//选中
        
        cell.product.productStatus = kProductWillBePurchased;
        self.statisticsView.totalPrice = _ShoppingCar.commitPrice;
        
    } else {//不选中
        
        cell.product.productStatus = kProductInShoppingCar;
        self.statisticsView.totalPrice = _ShoppingCar.commitPrice;
    }
}

#pragma mark -
#pragma mark BQShoppingCarStatisticsViewDelegate
/** 购物车中商品是否全选 */
- (void)shoppingCarStatisticsViewSelectAllProduct:(BOOL)isSelectAllProduct {
    
    if (isSelectAllProduct) {
        
        for (BQProduct *product in _ShoppingCar.productInShoppingCar) {
            product.productStatus = kProductWillBePurchased;
        }
        self.statisticsView.totalPrice = _ShoppingCar.commitPrice;
        
    } else {
        for (BQProduct *product in _ShoppingCar.productInShoppingCar) {
            product.productStatus = kProductInShoppingCar;
        }
        self.statisticsView.totalPrice = _ShoppingCar.commitPrice;
    }
}

- (void)commitOrder {
    
    BQPaymentController *controller = [BQPaymentController new];
    NSMutableArray *selectedProductArray = [NSMutableArray array];
    
    for (BQProduct *product in _ShoppingCar.productInShoppingCar) {
        if (product.productStatus == kProductWillBePurchased) {
            [selectedProductArray addObject:product];
        }
    }
    controller.productArray = selectedProductArray.copy;
    
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark -
#pragma mark BQPaymentControllerDelegate
- (void)paymentSuccessed {
    
    for (BQProduct *product in _ShoppingCar.productInShoppingCar) {
        if (product.productStatus == kProductAlreadyPurchased) {
            
            NSInteger count = [product.hasChoseCount integerValue];
            for (int i = 0; i < count; i ++) {
                [_ShoppingCar removeProduct:product];
            }
        }
    }
    [self.tableView reloadData];
    self.statisticsView.totalPrice = _ShoppingCar.commitPrice;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 20;
        default:
            return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 20;
        default:
            return 0.01;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.currentProduct = _ShoppingCar.productInShoppingCar[indexPath.row];
        
        [self showAlert];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 4) {
        BQDetailViewController *targetVC = [[BQDetailViewController alloc]init];
        targetVC.model = _ShoppingCar.productInShoppingCar[indexPath.row];
        [self.navigationController pushViewController:targetVC animated:YES];
    }
    
}

@end
