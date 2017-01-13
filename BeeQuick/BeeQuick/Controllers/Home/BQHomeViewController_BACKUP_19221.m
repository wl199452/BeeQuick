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
#import "BQActivitiesCell.h"

#import "BQHomeDetailCell.h"

static NSString *IconsCell = @"IconsCell";
static NSString *ActivitiesCell = @"ActivitiesCell";
static NSString *testCell = @"cell";

static NSString *ThirdCell = @"thirdCell";
 
@interface BQHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
 
@property (nonatomic,weak)UITableView *mainTableView;
 
@property (nonatomic,strong)BQHomeModel *homeModel;

//第三个cell 的数据
@property(nonatomic,strong)NSArray<BQProduct *> *detailsArray;

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
      [model  getDetailInfoWithCompleteBlock:^(NSArray<BQProduct *> *detailsArray) {
          if (detailsArray != nil) {
              _detailsArray = detailsArray;
              [self.mainTableView reloadData];
          }
      } ];
      
     
     }
- (void)registerNotification{
     
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:@"DOWNLOADCOMPLETE" object:nil];

<<<<<<< HEAD
=======
     
>>>>>>> d2ac1961e886ab23b32237084d438d73fea9e397
     }
-(void)reloadTableView:(NSNotification *)noti{
    
    [self.mainTableView reloadData];
    [self setCycleScrollView];
     
    
}
- (void) setTableView{
<<<<<<< HEAD
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.mainTableView = tableView;
    [self.view addSubview:tableView];
=======
     
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        self.mainTableView = tableView;
        [self.view addSubview:tableView];
     
         //注册cell
        [tableView registerClass:[BQHomeIconsCell class] forCellReuseIdentifier:IconsCell];
        [tableView registerClass:[BQActivitiesCell class] forCellReuseIdentifier:ActivitiesCell];
    
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:testCell];

>>>>>>> d2ac1961e886ab23b32237084d438d73fea9e397
    
    //注册cell
    [tableView registerClass:[BQHomeIconsCell class] forCellReuseIdentifier:IconsCell];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:testCell];
    
    
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    
#pragma mark --
#pragma mark - 第三个Cell
    [tableView registerClass:[BQHomeDetailCell class] forCellReuseIdentifier:ThirdCell];
    
    
}

//设置组间间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }
    return 10;
}
-(void)setCycleScrollView{
    
    SDCycleScrollView *cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140) imageURLStringsGroup:self.homeModel.focusImgURLs];
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
<<<<<<< HEAD
         if (section == 1) {
         
             return  self.homeModel.activitiesArray.count;
             }
     if (section == 2) {
         
       NSInteger res =  self.detailsArray.count % 2;
         if (res) {
             return self.detailsArray.count / 2 +1;
         }else{
             return self.detailsArray.count / 2;
         }
         
     }
         return 1;
=======
     return 1;
>>>>>>> d2ac1961e886ab23b32237084d438d73fea9e397
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
     
     if(indexPath.section == 1){
         
         BQActivitiesCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivitiesCell];
         
         if (self.homeModel.activitiesArray != nil) {
             cell.model = self.homeModel;
             
         }
         
<<<<<<< HEAD
             }
     if (indexPath.section == 1) {
         //4个小cell
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
         cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
         cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;

         
=======
         return cell;
         
         
     }
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
>>>>>>> d2ac1961e886ab23b32237084d438d73fea9e397
     }
#pragma mark --
#pragma mark -  第三个cell
     
     else{
              BQHomeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ThirdCell forIndexPath:indexPath];
         
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         
         cell.backgroundColor = [UIColor cyanColor];
             return cell;
     }
     
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 200;
    }
    else{
        return 80;
    }
    
}


- (void)dealloc{
     
<<<<<<< HEAD
         [[NSNotificationCenter defaultCenter]removeObserver:self];
=======
    [[NSNotificationCenter defaultCenter]removeObserver:self];
     
>>>>>>> d2ac1961e886ab23b32237084d438d73fea9e397
}
@end
