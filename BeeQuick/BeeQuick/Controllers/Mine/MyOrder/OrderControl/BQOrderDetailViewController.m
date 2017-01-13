//
//  BQOrderDatailViewController.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "BQOrderDetailViewController.h"
#import "BQOrderViewModel.h"
#import "BQStatusModel.h"
#import "BQOrderStateCell.h"
#import "BQOrderCellViewModel.h"
#import "BQOrderIDCell.h"
#import "BQOrderDetailModel.h"

static NSString *stateCellId = @"stateCellId";

static NSString *orderIDCellID = @"orderIDCellID";

static NSString *IDcell = @"IDcell";

static NSString *infoID = @"infoID";

static NSString *commonCell = @"commonCell";

@interface BQOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UITableView *stateTableView;

@property(nonatomic,weak)UITableView *detailTableView;

@property(nonatomic,weak)UISegmentedControl *segment;

@property(nonatomic,weak)UIView *view1;

@property(nonatomic,weak)UIView *view2;

@property(nonatomic,weak)UIView *lineView;

@property(nonatomic,strong)BQOrderDetailModel *orderViewModel;

@end

@implementation BQOrderDetailViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupNavUI];
    
    [self setupOrderStateUI];
    
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(collect:) name:@"collect" object:nil];
}

- (void) collect:(NSNotification*) notification
{
    NSString *message = @"收 藏";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alert addAction:action];
    
    [alert addAction:cancel];
    
    [self showDetailViewController:alert sender:nil];
}


#pragma mark - 搭建导航栏界面
- (void)setupNavUI {
    
    // 左上角返回按钮
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v2_goback"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItem = leftitem;
    
    
    //投诉
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"投诉" style:UIBarButtonItemStylePlain target:self action:@selector(tousu)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"订单状态",@"订单详情"]];
    segment.selectedSegmentIndex = 0;
    
    _segment = segment;
    
    
    //背景黄色
    segment.tintColor = kMainColor;
    
    //字体颜色
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
    
     [segment setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor grayColor]} forState:UIControlStateNormal];
    
    self.navigationItem.titleView = segment;
    
    [segment addTarget:self action:@selector(changeVc:) forControlEvents:UIControlEventValueChanged];
    
}

#pragma mark - 删除订单 -
- (void)tousu{
    
    NSString *message = @"投诉";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self showDetailViewController:alert sender:nil];
}


#pragma mark - 切换视图
- (void)changeVc:(UISegmentedControl*)segment {
    
    switch (segment.selectedSegmentIndex) {
            
        case 0:
            [self.detailTableView removeFromSuperview];
            
            [self setupOrderStateUI];
            
            break;
        case 1:
            [self.stateTableView removeFromSuperview];
            
            [self setupOrderDetailUI];
            
            break;
        default:
            break;
    }
}


#pragma Mark - 订单状态界面
- (void)setupOrderStateUI
{
    UITableView *stateTableView = [[UITableView alloc]init];
    
    _stateTableView = stateTableView;
    
    [self.view addSubview:stateTableView];
    
    [stateTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
    stateTableView.delegate = self;
    
    stateTableView.dataSource = self;
    

    [stateTableView registerNib:[UINib nibWithNibName:@"BQOrderStateCell" bundle:nil] forCellReuseIdentifier:stateCellId];
    
    stateTableView.rowHeight = 88;
    
    //使tableview不能点击只能滑动
    stateTableView.allowsSelection = NO;
    
    stateTableView.tableFooterView = [UIView new];
    
    stateTableView.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0);
    
    //创建
    UIView *view1 = [[UIView alloc] init];
    
    view1.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view1];
    
    self.view1 = view1;
    
    
    UIView *lineview = [[UIView alloc] init];
    
    lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    view1.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:lineview];
    
    self.lineView = lineview;
    
    
    UIButton *btn = [[UIButton alloc] init];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"v2_coupon_verify_normal"] forState:UIControlStateNormal];
    
    [btn setTitle:@"删除订单" forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(pushToAddLocatonViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [view1 addSubview:btn];
    
    //约束
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(60);
        
        make.left.bottom.right.mas_equalTo(self.view);
        
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.view1.mas_centerY);
        
        make.trailing.equalTo(self.view1).offset(-30);
        
        make.width.mas_equalTo(60);
        
        make.height.mas_equalTo(25);
    }];
    
    
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view1.mas_top);
        
        make.leading.trailing.equalTo(self.view1);
        
        make.height.mas_equalTo(1);
        
    }];
    
}

- (void)pushToAddLocatonViewController:(UIButton *)button
{
    [self deleteOrder];
}


#pragma mark - 删除订单 -
- (void)deleteOrder{
    
    NSString *message = @"删除订单";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self showDetailViewController:alert sender:nil];
}



#pragma Mark - 订单详情界面
- (void)setupOrderDetailUI {
    
    UITableView *detailTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    _detailTableView = detailTableView;
    
    [self.view addSubview:detailTableView];
    
    [detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    detailTableView.delegate = self;
    
    detailTableView.dataSource = self;
    
    [detailTableView registerClass:[BQOrderIDCell class] forCellReuseIdentifier:orderIDCellID];
    
    [detailTableView registerNib:[UINib nibWithNibName:@"BQOrderIDCell" bundle:nil] forCellReuseIdentifier:IDcell];
    
    [detailTableView registerNib:[UINib nibWithNibName:@"BQOrderInfoCell" bundle:nil] forCellReuseIdentifier:infoID];
    
    [detailTableView registerNib:[UINib nibWithNibName:@"BQOrdercommonCell" bundle:nil] forCellReuseIdentifier:commonCell];
    
    //使tableview不能点击只能滑动
    detailTableView.allowsSelection = NO;
    
    detailTableView.rowHeight = UITableViewAutomaticDimension;
    
    detailTableView.estimatedRowHeight = 120;
    //detailTableView.separatorInset = UIEdgeInsetsMake(0, 200, 0, 0);
    
    //创建
    UIView *view2 = [[UIView alloc] init];
    
    view2.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view2];
    
    self.view2 = view2;
    
    UIButton *btn = [[UIButton alloc] init];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"v2_coupon_verify_normal"] forState:UIControlStateNormal];
    
    [btn setTitle:@"删除订单" forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(pushToAddLocatonViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [view2 addSubview:btn];
    
    UIView *lineview = [[UIView alloc] init];
    
    lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    view2.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:lineview];
    
    self.lineView = lineview;

    //约束
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(60);
        
        make.left.bottom.right.mas_equalTo(self.view);
        
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.view2.mas_centerY);
        
        make.trailing.equalTo(self.view2).offset(-30);
        
        make.width.mas_equalTo(60);
        
        make.height.mas_equalTo(25);
    }];
    
    
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view2.mas_top);
        
        make.leading.trailing.equalTo(self.view2);
        
        make.height.mas_equalTo(1);
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.segment.selectedSegmentIndex == 0) {
        
        return 1;
    }
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segment.selectedSegmentIndex == 0) {
        
        return self.statusModelList.count;
    }
    
    switch (section) {
        case 0:
            return 7;
        case 1:
            //return 3;
            return 1;
            
        case 2:
            return 1;
        case 3:
            return 1;

        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex == 0) {
        
        BQOrderStateCell *cell = [tableView dequeueReusableCellWithIdentifier:stateCellId forIndexPath:indexPath];
    
        cell.model = self.statusModelList[indexPath.row];
    
        if (indexPath.row == self.statusModelList.count-1) {
            
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
            
        }
    
        return cell;
    }
    
//    BQOrderIDCell *cell = [tableView dequeueReusableCellWithIdentifier:orderIDCellID forIndexPath:indexPath];
    
    switch (indexPath.section) {
            
        case 0: {
        
            BQOrderIDCell *cell = [tableView dequeueReusableCellWithIdentifier:orderIDCellID forIndexPath:indexPath];

            
            cell.textLabel.text = self.detailModel.strArr[indexPath.row];
            
            return cell;
        }
        case 1: {
            
            BQOrderIDCell *cell = [tableView dequeueReusableCellWithIdentifier:IDcell forIndexPath:indexPath];
            
            //cell.viewDEModel = self.orderViewModel.
            
            //cell.viewDEModel = self.detailModel[indexPath.row];
            
            return cell;
        }
        case 2: {
            
            BQOrderIDCell *cell = [tableView dequeueReusableCellWithIdentifier:infoID forIndexPath:indexPath];

            
            //cell.textLabel.text = self.detailModel.strArr[indexPath.row];
            
            return cell;
        }
        case 3: {
            
            BQOrderIDCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell forIndexPath:indexPath];

            //cell.textLabel.text = self.detailModel.strArr[indexPath.row];
            
            return cell;
        }
            
        default:
            return nil;
    }
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.segment == 0) {
        
        return 0;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.segment == 0) {
        
        return 0;
    }
    return 0.1;
}


@end
