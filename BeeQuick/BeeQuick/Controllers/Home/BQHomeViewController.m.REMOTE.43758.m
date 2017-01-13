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
#import "BQHomeDetailCellView.h"
#import "BQProduct.h"
#import "BQDetailViewController.h"
#import "BQHomeFooterView.h"
//#import "BQSuperMarketViewController.h"
#import "BQTabBarController.h"

static NSString *IconsCell = @"IconsCell";
static NSString *ActivitiesCell = @"ActivitiesCell";
static NSString *testCell = @"cell";

static NSString *ThirdCell = @"thirdCell";
 
@interface BQHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
 
@property (nonatomic,weak)UITableView *mainTableView;
 
@property (nonatomic,strong)BQHomeModel *homeModel;

//第三个cell 的数据
@property(nonatomic,strong)NSArray<BQProduct *> *detailsArray;

//分解的cell的左边View的数组集合
@property(nonatomic,strong)NSArray<BQProduct *> *leftArr;
//分解的cell的右边View的数组集合
@property(nonatomic,strong)NSArray<BQProduct *> *rightArr;


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
      
#pragma mark --
#pragma mark -对拿到的数据进行左右拆分
      [model  getDetailInfoWithCompleteBlock:^(NSArray<BQProduct *> *detailsArray) {
          if (detailsArray == nil) {
              return ;
          }
          _detailsArray = detailsArray;
          NSMutableArray *arrM1 = [NSMutableArray array];
          NSMutableArray *arrM2 = [NSMutableArray array];
          for (int i = 0; i <detailsArray.count ; i++) {
              if (i%2 == 1) {
                  [arrM1 addObject:detailsArray[i]];
              }
              else{
                  [arrM2 addObject:detailsArray[i]];
              }
          }
          
          self.leftArr = arrM1;
          self.rightArr = arrM2;
          
          [self.mainTableView reloadData];
          
      } ];
      
      
  }
- (void)registerNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:@"DOWNLOADCOMPLETE" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickCell:) name:BeeQuickClickCellJumpNotifacation object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickMoreInfo) name:HomeFooterViewClickMoreBtnNotifacation object:nil];
    
}
-(void)reloadTableView:(NSNotification *)noti{
    
    [self.mainTableView reloadData];
    [self setCycleScrollView];
    
    //    self.homeModel = noti.userInfo[@"info"];
    [self.mainTableView reloadData];
    [self setCycleScrollView];
    
}


-(void)clickMoreInfo{
    
    BQTabBarController *tabVC = (BQTabBarController *) self.navigationController.parentViewController;
    tabVC.selectedIndex = 1;
}

-(void)clickCell:(NSNotification *)noti{
    
    BQHomeDetailCellView *detailCellView = noti.userInfo[kCellView];
    
    BQDetailViewController *targetVC = [[BQDetailViewController alloc]init];
    detailCellView.productModel = targetVC.model;
    [self.navigationController pushViewController:targetVC animated:YES];
    
}

- (void) setTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.mainTableView = tableView;
    [self.view addSubview:tableView];
    
    //注册cell
    [tableView registerClass:[BQHomeIconsCell class] forCellReuseIdentifier:IconsCell];
    [tableView registerClass:[BQActivitiesCell class] forCellReuseIdentifier:ActivitiesCell];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:testCell];
    
    
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
    if (section == 2) {
        return 120;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }
  
    return 30;
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
     if (indexPath.section == 1) {
         //4个小cell
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
         cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
         cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
         
         
     }
#pragma mark --
#pragma mark -  第三个cell
     
     else{
              BQHomeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ThirdCell forIndexPath:indexPath];
         
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         
//         self.detailsArray[indexPath.row]
         cell.leftModel = self.leftArr[indexPath.row];
         cell.rightModel = self.rightArr[indexPath.row];
         
         cell.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
             return cell;
     }
     
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 260;
    }
    else{
        return 100;
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 0, 50)];
        headView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.view addSubview:headView];

        UILabel *lbl = [UILabel new];
        [headView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headView);
            make.leading.equalTo(headView).mas_offset(8);
        }];
        
        lbl.text = @"新鲜热卖";
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textColor = RGBCOLOR(132, 132, 132);
        
        return headView;
        
    }
    
    return nil;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
    
        BQHomeFooterView *footerView = [BQHomeFooterView homeFooterView];
        footerView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.view addSubview:footerView];
        
        return footerView;
    }
    
    return nil;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
    
    //设置cell 按照z轴旋转90度，注意是弧度
    if (indexPath.section == 2) {
        NSArray *array =  tableView.indexPathsForVisibleRows;
        NSIndexPath *firstIndexPath = array[0];
        
        NSLog(@"----->%zd",firstIndexPath.row);
        NSLog(@"-------->%zd",indexPath.row);
        
        //设置anchorPoint
        cell.layer.anchorPoint = CGPointMake(0, 0.5);
        //为了防止cell视图移动，重新把cell放回原来的位置
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
        
        if (firstIndexPath.row < indexPath.row  ) {
            cell.layer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1.0);
        }else{
            cell.layer.transform = CATransform3DMakeRotation(- M_PI_4, 0, 0, 1.0);
        }
    }
    

    [UIView animateWithDuration:2.0 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1.0;
    }];
}



- (void)dealloc{
     
         [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
