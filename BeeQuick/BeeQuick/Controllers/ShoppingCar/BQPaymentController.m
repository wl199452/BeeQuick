//
//  BQPaymentController.m
//  BeeQuick
//
//  Created by Mac on 16/12/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQPaymentController.h"
#import "BQPaymentCouponCell.h"
#import "BQPaymentTypeCell.h"
#import "BQCostDetailCell.h"
#import "BQPaymentProductCell.h"
#import "BQPaymentCommitView.h"
#import "BQProduct.h"
#import "UILabel+Addition.h"

@interface BQPaymentController ()<UITableViewDelegate, UITableViewDataSource, BQPaymentCommitViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** 支付方式的图片数组 */
@property (nonatomic, strong) NSArray<UIImage *> *paymentTypeImageArray;

/** 支付方式 */
@property (nonatomic, strong) NSArray *paymentTypeTitleArray;

/** 支付方式选择数组 */
@property (nonatomic, strong) NSMutableArray *paymentTypeSelected;

/** 费用明细项目 */
@property (nonatomic, strong) NSArray *costDetailTextArray;

/** 费用明细价格 */
@property (nonatomic, strong) NSArray *costDetailPriceArray;

/** 底部的提交视图 */
@property (nonatomic, strong) BQPaymentCommitView *commitView;

/** 组标题 */
@property (nonatomic, strong) NSArray *sectionTitleArray;

/** 商品总价格 */
@property (nonatomic, assign) float totalPrice;

/** 优惠券金额 */
@property (nonatomic, assign) float couponDiscount;

/** 上一次被选中的支付类型cell */
//@property (nonatomic, strong) BQPaymentTypeCell *lastSelectedCell;
@property (nonatomic, assign) NSInteger lastCellIndex;

@end


static NSString *paymentCouponCellID = @"paymentCouponCellID";
static NSString *paymentTypeCellID = @"paymentTypeCellID";
static NSString *costDetailCellID = @"costDetailCellID";
static NSString *paymentProductCellID = @"paymentProductCellID";

@implementation BQPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self paymentArray];
    
    [self setupTableView];
    
    [self setupNavBar];
    
    [self setupCommitView];
}

- (void)paymentArray {
    
    //商品总价格
    self.totalPrice = 0.0;
    for (BQProduct *product in self.productArray) {
        self.totalPrice += [product.partner_price floatValue] * [product.hasChoseCount integerValue];
    }
    
    self.couponDiscount = 5.0;
    
    if (self.totalPrice < self.couponDiscount) {
        self.couponDiscount = 0.0;
    }
    
    self.paymentTypeImageArray = @[[UIImage imageNamed:@"v2_weixin"],
                                   [UIImage imageNamed:@"icon_qq"],
                                   [UIImage imageNamed:@"zhifubaoA"],
                                   [UIImage imageNamed:@"v2_dao"]];
    
    self.paymentTypeTitleArray = @[@"微信支付",
                              @"QQ支付",
                              @"支付宝支付",
                              @"货到付款"];
    
    self.paymentTypeSelected = [NSMutableArray arrayWithObjects:@(YES),@(NO),@(NO),@(NO), nil];
    
    self.costDetailTextArray = @[@"商品总额",
                            @"配送费",
                            @"服务费",
                            @"优惠券"];
    
    self.sectionTitleArray = @[@"  选择支付方式",@"  精选商品",@"  费用明细"];
    
    self.costDetailPriceArray = @[@(self.totalPrice),@0,@0,@(self.couponDiscount)];
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:SCREEN_BOUNDS style:UITableViewStyleGrouped];
    self.tableView.frame = self.view.frame;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarH+kNavigationBarH+kStatusBarH, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BQPaymentCouponCell" bundle:nil] forCellReuseIdentifier:paymentCouponCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"BQPaymentTypeCell" bundle:nil] forCellReuseIdentifier:paymentTypeCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"BQCostDetailCell" bundle:nil] forCellReuseIdentifier:costDetailCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"BQPaymentProductCell" bundle:nil] forCellReuseIdentifier:paymentProductCellID];
    
}

- (void)setupNavBar {
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"v2_goback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"结算付款";
}

- (void)setupCommitView {
    
    self.commitView = [BQPaymentCommitView paymentCommitView];
    [self.view addSubview:self.commitView];
    [self.commitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(kTabBarH);
    }];
    
    self.commitView.delegate = self;
    self.commitView.totalPrice = self.totalPrice - self.couponDiscount;
}

- (void)goback {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 1;
            break;
        case 1:
            row = self.paymentTypeTitleArray.count;
            break;
        case 2:
            row = self.productArray.count;
            break;
        case 3:
            row = self.costDetailTextArray.count;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            BQPaymentCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:paymentCouponCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 1:
        {
            BQPaymentTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:paymentTypeCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.paymentTypeIamge = self.paymentTypeImageArray[indexPath.row];
            cell.paymentTypeTitle = self.paymentTypeTitleArray[indexPath.row];
            cell.isSelected = [self.paymentTypeSelected[indexPath.row] boolValue];
            return cell;
        }
        case 2:
        {
            BQPaymentProductCell *cell = [tableView dequeueReusableCellWithIdentifier:paymentProductCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.product = self.productArray[indexPath.row];
            return cell;
        }
        case 3:
        {
            BQCostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:costDetailCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.costDetailTitle = self.costDetailTextArray[indexPath.row];
            cell.costDetailPrice = [self.costDetailPriceArray[indexPath.row] floatValue];
            return cell;
        }
        default:
            return nil;
            break;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!section) {
        return 0.01;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {

        self.paymentTypeSelected[self.lastCellIndex] = @(NO);
        self.paymentTypeSelected[indexPath.row] = @(YES);
        self.lastCellIndex = indexPath.row;
        [tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!section) {
        return nil;
    }
    UILabel *label = [UILabel labelWithName:self.sectionTitleArray[section - 1] font:[UIFont systemFontOfSize:14] textColor:[UIColor lightGrayColor]];
    label.backgroundColor = [UIColor whiteColor];
    return label;
}


#pragma mark -
#pragma mark BQPaymentCommitViewDelegate
- (void)commitPayment {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:self.paymentTypeTitleArray[self.lastCellIndex] delegate:self cancelButtonTitle:@"支付失败☹️" destructiveButtonTitle:@"支付成功👌😂" otherButtonTitles: nil];
    [sheet showInView:self.view];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            //支付成功
            if ([self.delegate respondsToSelector:@selector(paymentSuccessed)]) {
                
                //修改商品状态
                for (BQProduct *product in self.productArray) {
                    product.productStatus = kProductAlreadyPurchased;
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate paymentSuccessed];
            }
        }
            break;
        case 1:
        {
            //支付失败
        }
            break;
        default:
            break;
    }
}

@end
