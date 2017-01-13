//
//  BQMyMessageController.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQMyMessageController.h"
#import "BQUserView.h"
#import "BQSystemMsgViewModel.h"
#import "JQMessageTitleCell.h"
#import "BQSystemModel.h"

static NSString *systemCellID = @"systemCellID";

static NSString *contentCellID = @"contentCellID";


@interface BQMyMessageController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)BQSystemMsgViewModel *viewModel;


@property (nonatomic, weak) UISegmentedControl *segment;

@property(nonatomic,strong)UITableView *systemView;

@property(nonatomic,strong)BQUserView *userView;

@end

@implementation BQMyMessageController


- (BQSystemMsgViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[BQSystemMsgViewModel alloc]init];
    }
    return _viewModel;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"我的消息";
 
    [self.viewModel loadData:^(BOOL isSuccess) {
        
        [self.systemView reloadData];
        
    }];
    
    [self setNav];
    
    [self setupSystemUI];
    
    [self setUPUI];
}




- (void)setNav
{
    // 左上角返回按钮
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v2_goback"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)setUPUI
{
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"系统信息", @"用户消息"]];
    
    for (int i = 0; i < segment.numberOfSegments; i++) {
        
        [segment setWidth:80 forSegmentAtIndex:i];
    }
    
    self.navigationItem.titleView = segment;
    
    //设置默认选中
    segment.selectedSegmentIndex = 0;
    
    //监听点击
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    
    _segment = segment;
    
    _segment.tintColor = kMainColor;
    
    [self.view addSubview:self.userView];
    
    [self.view addSubview:self.systemView];
    
    
    [_systemView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];

}
- (void)segmentClick:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
            
        case 0:
            
            [self.systemView removeFromSuperview];
            
            [self setupSystemUI];
            
            break;
        case 1:
            [self.userView removeFromSuperview];
            
            [self setupuserUI];
            
            break;
            
        default:
            break;
    }

}



- (void)setupuserUI {
    
    _userView = [[[NSBundle mainBundle]loadNibNamed:@"BQUserView" owner:nil options:nil]lastObject];
    
    _userView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.userView];
    
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - 搭建系统消息界面
- (void)setupSystemUI {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _systemView = tableView;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"JQMessageTitleCell" bundle:nil] forCellReuseIdentifier:systemCellID];
    
    [tableView registerNib:[UINib nibWithNibName:@"JQMessageContentCell" bundle:nil] forCellReuseIdentifier:contentCellID];
    
    tableView.estimatedRowHeight = 60;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.viewModel.modelList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = indexPath.row == 0 ? systemCellID : contentCellID;
    
    JQMessageTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.model = self.viewModel.modelList[indexPath.section];
    
    cell.showBtn.tag = indexPath.section;
    
    __weak typeof(self) weakSelf = self;
    
    cell.block_ReloadTableView = ^(BQSystemModel *model,NSInteger index){
        
        //改变数据
        [weakSelf.viewModel.modelList replaceObjectAtIndex:indexPath.section withObject:model];
        
        //刷新界面
        [tableView reloadData];
        
    };
    
    return cell;
    
    
}

- (void)popViewController
{
    NSLog(@"使用过则");
}



@end
