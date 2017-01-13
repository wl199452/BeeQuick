//
//  BQHelpController.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQHelpController.h"
#import "AXFProblemController.h"

static NSString *cell_id = @"help_cell";

@interface BQHelpController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *heleTavleView;

@property(nonatomic,strong) UIWebView *webView;

@end

@implementation BQHelpController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"客服帮助";
    
    [self navBtn];
    
    [self setupUI];
}

#pragma mark
#pragma mark - nav按钮
- (void)navBtn
{
    // 左上角返回按钮
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v2_goback"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark
#pragma mark - 初始化界面
- (void)setupUI
{
    UITableView *heleTavleView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    heleTavleView.delegate = self;
    
    heleTavleView.dataSource = self;
    
    heleTavleView.scrollEnabled =NO;
    
    [heleTavleView registerClass:[UITableViewCell class] forCellReuseIdentifier:cell_id];
    
    [self.view addSubview:heleTavleView];
    
    self.heleTavleView = heleTavleView;
    
    [heleTavleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view);
        
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}

#pragma mark
#pragma mark - 代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *infoArray = @[@"客服电话:400-8484-842",@"常见问题"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = infoArray[0];
    }
    if (indexPath.row == 1) {
        
        cell.textLabel.text = infoArray[1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        [self callPhone];
    }
    
    if (indexPath.row == 1) {
        
        AXFProblemController *vc = [[AXFProblemController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}



#pragma mark - 打电话 -
- (void)callPhone{
    
    NSString *message = @"400-8484-842";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拨打" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        if (_webView) {
            
            _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel://10010"]]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self showDetailViewController:alert sender:nil];
}

@end
