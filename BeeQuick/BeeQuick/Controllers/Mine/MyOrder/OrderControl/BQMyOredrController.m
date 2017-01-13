//
//  BQMyOredrController.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQMyOredrController.h"
#import "BQOrderViewModel.h"
#import "BQOrderCell.h"
#import "BQOrderCellViewModel.h"
#import "BQOrderDetailViewController.h"

static NSString *orderCellId = @"orderCellId";

@interface BQMyOredrController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)BQOrderViewModel *orderViewModel;

@end

@implementation BQMyOredrController


- (BQOrderViewModel *)orderViewModel {
    
    if (!_orderViewModel) {
        
        _orderViewModel = [[BQOrderViewModel alloc]init];
    }
    return _orderViewModel;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"我的订单";
    
    [self setNav];
    
    [self setUPUI];
    
}

#pragma mark
#pragma mark - 设置导航栏按钮
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
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.orderViewModel loadData:^(BOOL isSuccess) {
        
        //NSLog(@"%@",self.orderViewModel.viewmodelArray[0].model);
        [tableView reloadData];
        
    }];
    
    
    [tableView registerNib:[UINib nibWithNibName:@"BQOrderCell" bundle:nil] forCellReuseIdentifier:orderCellId];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    //预估行高
    tableView.estimatedRowHeight = 250;
    

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orderViewModel.viewmodelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BQOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellId forIndexPath:indexPath];
    
    cell.viewModel = self.orderViewModel.viewmodelArray[indexPath.section];
   
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BQOrderDetailViewController *vc = [[BQOrderDetailViewController alloc]init];
    
    vc.statusModelList = self.orderViewModel.viewmodelArray[indexPath.section].status_timeline;
    
    vc.detailModel = self.orderViewModel.viewmodelArray[indexPath.section];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}



@end
