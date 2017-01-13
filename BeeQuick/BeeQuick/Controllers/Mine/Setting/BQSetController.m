//
//  BQSetController.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQSetController.h"
#import "BQAboubtAuthorController.h"
static NSString *set_cell = @"set_cell";

static NSString *about_cell = @"about_cell";

@interface BQSetController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) UITableView *setView;

@property(nonatomic,strong)UILabel *cache_label;

@end

@implementation BQSetController

- (instancetype)init{
    
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [self setNav];

    [self setupUI];
    
    
}

#pragma mark
#pragma mark - 左上角按钮
- (void)setNav
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
    [self.tableView registerNib:[UINib nibWithNibName:@"BQAbout" bundle:nil] forCellReuseIdentifier:about_cell];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:set_cell];
    
    self.tableView.scrollEnabled =NO;
}

#pragma mark
#pragma mark - 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 2;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *infoArray = @[@"关于小熊",@"清理缓存"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:set_cell forIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.textLabel.text = infoArray[0];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        cell.textLabel.text = infoArray[1];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60,3,50,30)];
        
        label.text = @"";  //设置内容
        
        label.font = [UIFont fontWithName:@"Arial" size:17.0]; //设置字体大小，字体
        
        label.textColor = [UIColor lightGrayColor]; //设置字体颜色
        
        [cell addSubview:label];
        
         self.cache_label = label;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        //计算缓存
        [self showCaChe];
        
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.textLabel.text = @"退出账号";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        BQAboubtAuthorController *aboutVc = [[BQAboubtAuthorController alloc]init];
        
        [self.navigationController pushViewController:aboutVc animated:YES];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        NSLog(@"清除缓存");
        
        [self putBufferBtnClicked];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        NSLog(@"退出当前登录");
    }
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - 清理缓存 -

- (void)showCaChe {
    CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
    self.cache_label.text = size > 1 ? [NSString stringWithFormat:@"%.0fM", size] : [NSString stringWithFormat:@"%.0fK", size * 1024.0];
}


//清除缓存按钮的点击事件
- (void)putBufferBtnClicked{
    
    NSString *message = @"删除缓存";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSTemporaryDirectory()];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self showDetailViewController:alert sender:nil];
}


// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
            
        }
    }
    self.cache_label.text = @"0K";
}


@end
