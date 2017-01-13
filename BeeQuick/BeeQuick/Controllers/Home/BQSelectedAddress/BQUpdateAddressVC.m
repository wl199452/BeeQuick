//
//  BQUpdateAddressVC.m
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQUpdateAddressVC.h"
#import "BQAddressCell.h"
#import <SVProgressHUD.h>
#import "BQSelAddressViewController.h"

@interface BQUpdateAddressVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)BQAddressCell *addressCell;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BQUpdateAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改地址";
    [self setGoBackButton];
    [self setsaveItem];



    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
    
    [self setupTableView];
    
    [self setupDeleteButton];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
     self.deleteButton.hidden = ((self.selectedIndex < 0) ? YES :NO) ;
}


- (void)setupTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) style:UITableViewStylePlain];
    
    self.tableView.rowHeight = 292;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.scrollEnabled = NO;
}

- (void)setupDeleteButton {
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setTitle:@"删除当前地址" forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.deleteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(49);
        make.top.equalTo(self.tableView.mas_bottom).offset(10);
    }];
    
    [self.deleteButton addTarget:self action:@selector(deleteCurrentAddress) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark -
#pragma mark 删除地址
- (void) deleteCurrentAddress {
    
    if (self.deleteCurrentAddressBlock) {
        self.deleteCurrentAddressBlock(self.infoModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 保存按钮
-(void)setsaveItem{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(clickSaveItem)];
    [saveItem setTintColor:[UIColor lightGrayColor]];
    self.navigationItem.rightBarButtonItem = saveItem;
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

-(void)clickSaveItem{
    
    [SVProgressHUD showWithStatus:@"已经保存"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        BQAddressModel *infoModel = [BQAddressModel new];
        infoModel.accept_name = _addressCell.contactsTextField.text;
        infoModel.telphone = _addressCell.phoneNumTextField.text;
        infoModel.address = _addressCell.addressTextF.text;
        infoModel.city_name = _addressCell.cityTextField.text;
        infoModel.addr_for_dealer = _addressCell.areaTextField.text;
        infoModel.gender = _addressCell.manBtn.isSelected ? @"1" : @"0";

        NSDictionary *dict = @{@"infoModel":infoModel,@"index":@(self.selectedIndex)};
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notiSave" object:self userInfo:dict];

        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

   BQAddressCell *cell =  [[[NSBundle mainBundle] loadNibNamed:@"BQAddressCell" owner:nil options:nil]lastObject];
    self.addressCell = cell;
    
    cell.infoModel = self.infoModel;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
