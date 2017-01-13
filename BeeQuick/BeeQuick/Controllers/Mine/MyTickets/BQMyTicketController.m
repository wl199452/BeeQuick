//
//  BQMyTicketController.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQMyTicketController.h"
#import "BQNetWorkTools.h"
#import "BQTicketModel.h"
#import "AXFDiscountCardCell.h"
#import "BQUseRegularController.h"
@interface BQMyTicketController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSArray<BQTicketModel *> *TicketArray;

@property (nonatomic, weak) UIView *topView;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation BQMyTicketController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"优惠券";
    
    [self setNav];
    
    [self setupTopView];
    
     [self setupTableView];
    
    [self requestData];

}


- (void)setNav
{
    // 左上角返回按钮
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v2_goback"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItem = item;
    
    // 右上角返回按钮
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"使用规则" style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    // 设置右上角的返回按钮
    self.navigationItem.rightBarButtonItem = rightitem;
}

- (void)popViewController
{
    BQUseRegularController *useRegularVC = [[BQUseRegularController alloc]init];
    
    [self.navigationController pushViewController:useRegularVC animated:YES];
}

- (void)requestData
{
    NSString *urlString = @"http://iosapi.itcast.cn/loveBeen/MyCoupon.json.php";
    
    [[BQNetWorkTools sharedTools]requestWithMethodType:POST urlString:urlString parameters:@{@"call":@"9"} finishedCallBackBlock:^(id responseObject, NSError *error) {
      
        if (error != nil) {
            
            NSLog(@"请求失败 %@",error);
        
        } else {
        
            //NSLog(@"%@",responseObject);
            
            NSArray *objArr = responseObject[@"data"];
            
            NSMutableArray *arrM = [NSMutableArray array];
            
            for (NSDictionary *dict in objArr) {
                
                BQTicketModel *model = [BQTicketModel new];
                
                [model yy_modelSetWithDictionary:dict];
                
                [arrM addObject:model];
            }
            
            _TicketArray = arrM.copy;
            
            [self.tableView reloadData];
        }
        
    }];
}

#pragma mark
#pragma mark - 顶部视图 -
- (void)setupTopView
{
    
    UIView *topView = [UIView new];
    
    [self.view addSubview:topView];
    
    self.topView.backgroundColor = [UIColor redColor];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        
        make.height.equalTo(@40);
        
    }];
    
    _topView = topView;
    
    UIButton *button = [UIButton buttonWithType:0];
    
    [topView addSubview:button];
    
    [button setBackgroundImage:[UIImage imageNamed:@"v2_coupon_verify_normal"] forState:UIControlStateNormal];
    
    [button setTitle:@"绑定" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [button addTarget:self action:@selector(bangnding:) forControlEvents:UIControlEventTouchUpInside];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(topView);
        
        make.trailing.equalTo(topView).offset(-18);
        
        make.width.equalTo(@60);
        
        make.height.equalTo(@30);
        
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    textField.font = [UIFont systemFontOfSize:15];
    
    [topView addSubview:textField];
    
    textField.placeholder = @"请输入优惠券号码";
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(topView);
        
        make.leading.equalTo(topView).offset(18);
        
        make.right.equalTo(button.mas_left).offset(-10);
        
    }];
}


#pragma mark - 绑定 -
- (void)bangnding:(UIButton *)btn {
    
    [self sure];
    
    [self.view endEditing:YES];
}


- (void)sure{
    
    NSString *message = @"请输入优惠码";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    
    [alert addAction:sure];
    
    [self showDetailViewController:alert sender:nil];
}



#pragma mark
#pragma mark - UITableView -
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topView.mas_bottom);
        
        make.left.right.bottom.equalTo(self.view);
        
    }];
    
    _tableView = tableView;
    
    tableView.dataSource = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"AXFInvalidDiscountCard" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"invalidDiscountCellID"];
    
    [tableView registerNib:[UINib nibWithNibName:@"AXFValidDiscountCard" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"validDiscountCellID"];
    
    tableView.estimatedRowHeight = 150;
    
    tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDeleDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_TicketArray) {
        
        return self.TicketArray.count;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellID = [NSString string];
    
    BQTicketModel *model = self.TicketArray[indexPath.row];
    
    if([model.status isEqualToString:@"0"])
    {
        cellID = @"validDiscountCellID";
    } else {
        
        cellID = @"invalidDiscountCellID";
    }
    
    AXFDiscountCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = self.TicketArray[indexPath.row].name;
    
    cell.startLabel.text = self.TicketArray[indexPath.row].start_time;
    
    cell.endLabel.text = self.TicketArray[indexPath.row].end_time;
    
    cell.descLabel.text = self.TicketArray[indexPath.row].desc;
    
    cell.valueLabel.text = self.TicketArray[indexPath.row].value;
    
    return cell;
}





@end
