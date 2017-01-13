//
//  ViewController.m
//  tableview  Test
//
//  Created by windzhou on 15/4/2.
//  Copyright (c) 2015年 zhoufeng. All rights reserved.
//

#import "AXFProblemController.h"
#import "AXFViewOfCustomerTableViewCell.h"
#import "AXFCustomerInfoSectionView.h"
#import "BQNetWorkTools.h"
#import "BQProblemModel.h"

#define MENU_HEADER_VIEW_KEY    @"headerview"
#define MENU_OPENED_KEY         @"open"
#define FILTER_TITLE_KEY        @"title"
#define FILTER_ITEMS_KEY        @"values"
#define FILTER_IMAGES_KEY       @"image"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *ViewOfCustomerTableViewCellIdentifier = @"ViewOfCustomerTableViewCellIdentifier";


@interface AXFProblemController ()<UITableViewDataSource,UITableViewDelegate,CustomerInfoSectionViewDelegate>

@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger openedSection;
@property(nonatomic,strong)NSArray *cellArray;

@property(nonatomic,strong)NSArray<BQProblemModel *>*problemList;
@end

@implementation AXFProblemController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    self.title = @"常见问题";
    
    [self setNav];
    
    self.openedSection = NSNotFound;
    _dataArray = [[NSMutableArray alloc]init];
    //_listTableView要显示的section数目
    for (int i = 0; i < 9; i++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:@"55555" forKey:@"detail"];
//        [dic setValue:self.problemList[i].title forKey:@"title"];
        [_dataArray addObject:dic];
        
//        NSString *str = @"问题";
//        [_dataArray addObject:str];
        
    }
    _cellArray = @[@"1"];//下拉显示的cell的数量
    
    self.view.backgroundColor = [UIColor whiteColor];

    //[self setupTableView];
}


- (void)setupTableView {
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth([UIScreen mainScreen].applicationFrame), [[UIScreen mainScreen] applicationFrame].size.height)  style:UITableViewStylePlain];
    
    _listTableView.estimatedRowHeight = 100;
    _listTableView.rowHeight = UITableViewAutomaticDimension;
    
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listTableView registerClass:[AXFViewOfCustomerTableViewCell class] forCellReuseIdentifier:ViewOfCustomerTableViewCellIdentifier];
    _listTableView.allowsSelection = YES;
    _listTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_listTableView];
    
}

- (void)loadData {
    
    NSString *urlString = @"http://iosapi.itcast.cn/loveBeen/help.json.php";
    
    NSDictionary *parameters = @{@"call":@"4"};
    
    [[BQNetWorkTools sharedTools]requestWithMethodType:POST urlString:urlString parameters:parameters finishedCallBackBlock:^(id responseObject, NSError *error) {
        
        //NSLog(@"%@",responseObject);
        if (error != nil) {
            return ;
        }
        
        NSArray *dataArr = responseObject[@"focus"];
    
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        for (NSDictionary *dict in dataArr) {
           BQProblemModel *model = [BQProblemModel yy_modelWithDictionary:dict];
        
            
            [tempArr addObject:model];
        }
        
        self.problemList = tempArr.copy;

        [self setupTableView];
        
    }];
    
}

- (void)setNav
{
    // 左上角返回按钮
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v2_goback"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    // 设置左上角的返回按钮
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark - Table View Delegate & Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //根据字典里的MENU_OPENED_KEY的值来显示或者隐藏下拉的cell
    NSMutableDictionary *sectionInfo = [_dataArray objectAtIndex:section];
    return [[sectionInfo objectForKey:MENU_OPENED_KEY] boolValue] ? [_cellArray count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableDictionary *dic = [_dataArray objectAtIndex:section];
    AXFCustomerInfoSectionView *view = [dic objectForKey:MENU_HEADER_VIEW_KEY];

    if (!view)
    {
        view = [[AXFCustomerInfoSectionView alloc]init];//
        [view initWithNameLabel:self.problemList[section].title ManagerNameLabel:@"" DepartmentLabel:@"" AddressLabel:@"" section:section delegate:self];
        [dic setObject:view forKey:MENU_HEADER_VIEW_KEY];
    }
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AXFViewOfCustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ViewOfCustomerTableViewCellIdentifier forIndexPath:indexPath];

    
    NSString *finalString = @"";
    NSArray<NSString *> *textArray = self.problemList[indexPath.section].texts;
    for (NSString *str in textArray) {
        finalString = [finalString stringByAppendingString:str];
        finalString = [finalString stringByAppendingString:@"\n"];
        finalString = [finalString stringByAppendingString:@"\n"];
        
    }
    cell.drscriptionLabel.text = finalString;
    
    [cell.drscriptionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(8);
        make.bottom.equalTo(cell.contentView).offset(-8);
    }];
    
    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark Section header delegate

-(void)sectionHeaderView:(AXFCustomerInfoSectionView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened
{
    NSMutableDictionary *sectionInfo = [_dataArray objectAtIndex:sectionHeaderView.section];
    [sectionInfo setObject:[NSNumber numberWithBool:YES] forKey:MENU_OPENED_KEY];//将当前打开的section标记为1
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_cellArray count]; i++)
    {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }//点击显示下拉的cell，将其加入到indexPathsToInsert数组中
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openedSection;
    if (previousOpenSectionIndex != NSNotFound)//有点开的section，这样打开新的section下拉菜单时要把先前的scetion关闭
    {
        NSMutableDictionary *previousOpenSectionInfo = [_dataArray objectAtIndex:previousOpenSectionIndex];
        AXFCustomerInfoSectionView *previousOpenSection = [previousOpenSectionInfo objectForKey:MENU_HEADER_VIEW_KEY];
        [previousOpenSectionInfo setObject:[NSNumber numberWithBool:NO] forKey:MENU_OPENED_KEY];
        [previousOpenSection toggleOpenWithUserAction:NO];//箭头方向改变
        [UIView animateWithDuration:.3 animations:^{
            previousOpenSection.arrow.transform = CGAffineTransformIdentity;
        }];
        for (int i = 0; i < [_cellArray count]; i++)//将要关闭的cell写入indexPathsToDelete数组中
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
        
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;//系统提供的显示下拉cell菜单动画
    UITableViewRowAnimation deleteAnimation;//关闭下拉菜单动画
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.listTableView beginUpdates];
    [self.listTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];//将之前插入到indexPathsToInsert数组中的cell都插入显示出来
    [self.listTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];//将之前打开得下拉菜单关闭
    [self.listTableView endUpdates];
   
    self.openedSection = sectionOpened;
}

-(void)sectionHeaderView:(AXFCustomerInfoSectionView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed
{
    NSMutableDictionary *sectionInfo = [_dataArray objectAtIndex:sectionHeaderView.section];
    [sectionInfo setObject:[NSNumber numberWithBool:NO] forKey:MENU_OPENED_KEY];
    NSInteger countOfRowsToDelete = [self.listTableView numberOfRowsInSection:sectionClosed];
    if (countOfRowsToDelete > 0)
    {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.listTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openedSection = NSNotFound;
}


@end
