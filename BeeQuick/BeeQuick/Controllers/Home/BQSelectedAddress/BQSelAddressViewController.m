//
//  BQSelAddressViewController.m
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQSelAddressViewController.h"
#import "BQUpdateAddressVC.h"
#import "BQNetWorkTools.h"
#import "BQMyReceiveAddressModel.h"
//#import "BQAddressModel.h"
#import "BQAddressCell.h"
#import "BQReceiveAddressCell.h"
#import "BQBaseViewController.h"
#import <SVProgressHUD.h>

@interface BQSelAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(weak,nonatomic)UIView *bottomAddAddressView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView * nullView;
@end

@implementation BQSelAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
    [self setupNavigationItem];
    
    [self setupBottomAddAddressButton];
    
    [self setGoBackButton];
    
    [self loadAddressData];
    
    [self setupTableView];
    
    [self setupNullView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fun:) name:@"notiSave" object:nil];
}


#pragma mark - 保存地址消息处理
-(void)fun:(NSNotification *)noti{
    
    BQAddressModel *infoModel = noti.userInfo[@"infoModel"];
    
    NSInteger index = [noti.userInfo[@"index"] integerValue];
    
    if (index >= 0) {
        
        [self.addressArray replaceObjectAtIndex:index withObject:infoModel];
    } else {
        [self.addressArray addObject:infoModel];
    }
    [BQAddressModel archiver:self.addressArray];
    
    [self refreshUI];
}

#pragma mark - setupNavigationItem
-(void)setupNavigationItem{
    self.navigationItem.title = @"我的收货地址";
}

- (void)setupTableView {
    
    self.tableView = [UITableView new];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = SCREEN_HEIGHT / 9.0;
    _tableView.estimatedRowHeight = SCREEN_HEIGHT / 9.0;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.top.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-kTabBarH);
    }];
    _tableView.backgroundColor = RGBCOLOR(239, 239, 239);
    _tableView.tableFooterView = [UIView new];
    
    _tableView.hidden = YES;
}

#pragma mark - 刷新UI
-(void)refreshUI{
    
    if (self.addressArray.count != 0) {
        [self.tableView reloadData];
        self.tableView.hidden = NO;
        self.nullView.hidden = YES;
    }else{
        self.tableView.hidden = YES;
        self.nullView.hidden = NO;
    }
}

#pragma mark - 加载地址数据
-(void)loadAddressData{
    
    [SVProgressHUD showWithStatus:@"正在加载地址..."];
    BQMyReceiveAddressModel *addressModel = [BQMyReceiveAddressModel new];
    WEAKSELF
    [addressModel loadAddressDataWithCompleteBlock:^(NSArray <BQAddressModel *> *addressArray) {

        weakSelf.addressArray = addressArray.mutableCopy;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [weakSelf refreshUI];
        });
    }];
    
}


#pragma mark - 添加空视图
-(void)setupNullView{
    
    self.nullView = [[UIView alloc]initWithFrame:SCREEN_BOUNDS];
//    [self.view addSubview:self.nullView];
    [self.view insertSubview:self.nullView atIndex:0];
//    [self.nullView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.leading.trailing.equalTo(self.view);
//        make.bottom.equalTo(self.bottomAddAddressView.mas_top);
//    }];
    
    UIImageView *nullImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"v2_address_empty"]];
    nullImageView.center = CGPointMake(self.nullView.center.x, self.nullView.center.y - 50);
    nullImageView.bounds = CGRectMake(0, 0, 90, 90);
    
    [self.nullView addSubview:nullImageView];
    
    UILabel *nullLabel = [[UILabel alloc]init];
    nullLabel.text = @"您还没有地址哦😯~";
    [nullLabel.font fontWithSize:12];
    nullLabel.textColor = [UIColor lightGrayColor];
    [self.nullView addSubview:nullLabel];
    [nullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nullImageView.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(nullImageView);
    }];
    self.nullView.hidden = YES;
}
#pragma mark - 添加地址按钮
-(void)setupBottomAddAddressButton{
    
    UIView *bottomAddAddressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTabBarH)];
    bottomAddAddressView.backgroundColor = [UIColor whiteColor];
    _bottomAddAddressView = bottomAddAddressView;
    [self.view addSubview:bottomAddAddressView];
    [bottomAddAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(kTabBarH);
    }];
    
    UIButton *bottomAddAddressButton = [[UIButton alloc]init];
    [bottomAddAddressButton setTitle:@"+ 新增地址" forState:UIControlStateNormal];
    [bottomAddAddressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomAddAddressButton setBackgroundImage:[UIImage imageNamed:@"icon_sendcoupon"] forState:UIControlStateNormal];
    [bottomAddAddressButton addTarget:self action:@selector(clickAddAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    
    bottomAddAddressButton.titleLabel.font =
    [UIFont systemFontOfSize:16];
    
    [self.bottomAddAddressView addSubview:bottomAddAddressButton];
    [bottomAddAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomAddAddressView);
        make.width.mas_equalTo(SCREEN_WIDTH / 1.2);
        make.height.mas_equalTo(kTabBarH - 10);
    }];
}

#pragma mark -
#pragma mark 增加地址事件
-(void)clickAddAddressBtn{
    
    BQUpdateAddressVC *updateAddVC = [BQUpdateAddressVC new];
    updateAddVC.selectedIndex = -1;
    
    [self.navigationController pushViewController:updateAddVC animated:YES];
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


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.addressArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BQReceiveAddressCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"BQReceiveAddressCell" owner:nil options:nil] lastObject];
    cell.addressModel = self.addressArray[indexPath.row];
    cell.editButton.tag = indexPath.row;
    [cell.editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *addressString = self.addressArray[indexPath.row].address;
    
    NSString *finalString = [[addressString componentsSeparatedByString:@" "] firstObject];
    
    //给购物车中的配送地址赋值
    _ShoppingCar.receiveAddress = finalString;
    
    if (self.modifyDeliveryAddressBlock) {
        self.modifyDeliveryAddressBlock(finalString);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 修改地址响应事件
-(void)clickEditButton:(UIButton *)button{
    BQUpdateAddressVC *myInfoVc = [BQUpdateAddressVC new];
    myInfoVc.infoModel = self.addressArray[button.tag];
    
    myInfoVc.selectedIndex = button.tag;
    WEAKSELF
    myInfoVc.deleteCurrentAddressBlock = ^(BQAddressModel *addressModel){
        [weakSelf.addressArray removeObject:addressModel];
        [BQAddressModel archiver:weakSelf.addressArray.copy];
        [weakSelf refreshUI];
    };
    
    [self.navigationController pushViewController:myInfoVc animated:YES];
}

@end
