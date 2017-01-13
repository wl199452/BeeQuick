//
//  BQProfileViewController.m
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQProfileViewController.h"
#import "BQMineTopView.h"
#import "BQMineModel.h"
#import "BQHeadView.h"
#import "BQMyOredrController.h"
#import "BQMyTicketController.h"
#import "BQMyMessageController.h"
#import "BQReceiveController.h"
#import "BQSetController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialUIManager.h"
#import "BQSelAddressViewController.h"

static NSString *cell_id = @"miney_cell";

@interface BQProfileViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)BQMineTopView *myTopView;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *mineArray;

@end

@implementation BQProfileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupTopView];
    
    [self setupTableView];
    
    [self setHidesView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"clickTopButton" object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(mytest:) name:@"mytest" object:nil];
    
    
}
- (void) mytest:(NSNotification*) notification
{
    BQSetController *setVC = [[BQSetController alloc]init];
    
    setVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:setVC animated:YES];
}

#pragma mark
#pragma mark - 通知
- (void)receiveNotification:(NSNotification *)notification{
  
    NSDictionary *dict = notification.userInfo;
    
    UIButton *button = dict[@"clickedButton"];
    
    switch (button.tag) {
            
        case kButtonOrder:{
            
            BQMyOredrController *orderVC = [[BQMyOredrController alloc]init];
            
            [self.navigationController pushViewController:orderVC animated:YES];
            
            NSLog(@"我的订单");
        }
            
            break;
            
        case kButtonTicket:{
        
            BQMyTicketController *ticketVC = [[BQMyTicketController alloc]init];
            
            [self.navigationController pushViewController:ticketVC animated:YES];
            
              NSLog(@"优惠券");
        }
            
            break;
            
        case kButtonMessage:{
            
            BQMyMessageController *messageVC = [[BQMyMessageController alloc]init];
            
            [self.navigationController pushViewController:messageVC animated:YES];
        
            NSLog(@"我的消息");
        }
            
            
        default:
            
            break;
    }
}



#pragma mark
#pragma mark - 隐藏导航栏
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


#pragma mark
#pragma mark - 加载数据
- (NSArray *)mineArray {
    
    if (!_mineArray) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"mine.plist" ofType:nil];
        
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *mArray = [NSMutableArray array];
        
        for (NSArray *detail in array) {
            
            NSMutableArray *mArr = [NSMutableArray array];
            
            for (NSDictionary *dict in detail) {
                
                BQMineModel *model = [[BQMineModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dict];
                
                [mArr addObject:model];
            }
            
            [mArray addObject:mArr];
        }
        
        _mineArray = mArray.copy;
        
        [self.tableView reloadData];
    }
    
    return _mineArray;
}

#pragma mark
#pragma mark - 初始化顶部视图
- (void)setupTopView
{
    //顶部视图
    BQMineTopView *myTopView = [[[NSBundle mainBundle] loadNibNamed:@"BQMineTopView" owner:nil options:nil] firstObject];
    
    myTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH * 0.4);
    
    self.myTopView = myTopView;
    
    [self.view addSubview:myTopView];
    
}


#pragma mark
#pragma mark - tableview表头
- (void)setHidesView
{
    BQHeadView *heardView = [[BQHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    
    heardView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = heardView;
}

#pragma mark
#pragma mark - 初始化tableview

- (void)setupTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cell_id];
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.myTopView.mas_bottom);
        
        make.leading.bottom.trailing.equalTo(self.view);
    }];
    
    _tableView = tableView;
}


#pragma mark
#pragma mark - 数据源代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.mineArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.mineArray[section];
    
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    
    NSArray *array = self.mineArray[indexPath.section];
    
    BQMineModel *model  = array[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.imageView.image = [UIImage imageNamed:model.iconName];
    
    cell.textLabel.text = model.title;
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    NSLog(@"%zd,%zd",indexPath.section,indexPath.row);
    
    

    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        [self sheard];
    }
    
    BQMineModel *model  = self.mineArray[indexPath.section][indexPath.row];

    NSString *str = model.pushVC;
    
    Class cls = NSClassFromString(str);
    
    if (cls == nil) {
        
        return;
    }
    
    //创建控制器并push
    UIViewController *vc = [[cls alloc] init];
    
//    self.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    // 左上角返回按钮
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v2_goback"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItem = item;
    
}

//分享
-(void)sheard{
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        
        [self shareTextToPlatformType:platformType];
    }];
}

- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}





@end
