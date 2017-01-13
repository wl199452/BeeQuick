//
//  BQHomeViewController.m
//  BeeQuick
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//


#import "BQHomeViewController.h"
#import "BQNetWorkTools.h"
#import "BQHomeModel.h"
#import <SDCycleScrollView.h>
#import "BQHomeIconsCell.h"

static NSString *IconsCell = @"IconsCell";
static NSString *testCell = @"cell";
 
@interface BQHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
 
@property (nonatomic,weak)UITableView *mainTableView;
 
@property (nonatomic,strong)BQHomeModel *homeModel;


@end


@implementation BQHomeViewController


 - (void)viewDidLoad {
    [super viewDidLoad];
         [self getData];
         [self registerNotification];
         [self setTableView];
     
     
     }
  - (void)getData{
     
         BQHomeModel *model = [BQHomeModel new];
         self.homeModel = model;
     
     }
- (void)registerNotification{
     
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:@"DOWNLOADCOMPLETE" object:nil];
     
     
     
     
     }
-(void)reloadTableView:(NSNotification *)noti{
     
     //    self.homeModel = noti.userInfo[@"info"];
         [self.mainTableView reloadData];
         [self setCycleScrollView];
     
    
     }
- (void) setTableView{
     
         UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
         self.mainTableView = tableView;
         [self.view addSubview:tableView];
     
         //注册cell
         [tableView registerClass:[BQHomeIconsCell class] forCellReuseIdentifier:IconsCell];
    
         [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:testCell];
         NSString *urlString = @"http://iosapi.itcast.cn/loveBeen/focus.json.php";
         NSDictionary *parameter = @{@"call":@"1"};
         [[BQNetWorkTools sharedTools] requestWithMethodType:POST urlString:urlString parameters:parameter finishedCallBackBlock:^(id responseObject, NSError *error) {
                 if (error) {
                         NSLog(@"%@",error);
                     }
                 //NSLog(@"%@",responseObject);
             }];
    
         tableView.rowHeight = 80;
         self.mainTableView.dataSource = self;
         self.mainTableView.delegate = self;
     }


-(void)setCycleScrollView{
    
         SDCycleScrollView *cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140) imageURLStringsGroup:self.homeModel.imgURLs];
         self.mainTableView.tableHeaderView = cycle;
    
     }
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
     
         NSLog(@"%ld",(long)index);
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
         return 3;
     }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
         if (section == 1) {
         
                 return self.homeModel.activitiesArray.count;
             }
         return 1;
     }
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
         if (indexPath.section == 0) {
                 BQHomeIconsCell *cell = [tableView dequeueReusableCellWithIdentifier:IconsCell];
         
                 if (self.homeModel.iconsArray != nil) {
                          cell.model = self.homeModel;
             
                     }
         
                 return cell;
         
             }
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
         cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
         cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
     }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
     
         [[NSNotificationCenter defaultCenter]removeObserver:self];
     
     /*
       #pragma mark   Navigation
       
       // In a storyboard based application, you will often want to do a little preparation before navigation
         (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
           // Get the new view controller using [segue destinationViewController].
           // Pass the selected object to the new view controller.
      }
       */
}
@end
