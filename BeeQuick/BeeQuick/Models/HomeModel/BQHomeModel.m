//
//  BQHomeModel.m
//  BeeQuick
//
//  Created by 风不会停息 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQHomeModel.h"
#import "BQNetWorkTools.h"
#import "BQCommonModel.h"
#import "BQProduct.h"
#import <YYModel.h>


@implementation BQHomeModel


- (instancetype)init{
    
    self = [super init];
    if ( self)
    {
        [self getHeadData];
        

    }
    return self;
    
}


- (void)getHeadData{
    
   
    
    
    NSDictionary *parameter = @{@"call": @(1)};
    
    
    [[BQNetWorkTools sharedTools]requestWithMethodType:POST urlString:@"http://iosapi.itcast.cn/loveBeen/focus.json.php" parameters:parameter finishedCallBackBlock:^(id responseObject, NSError *error) {
        if (error != nil) {
            NSLog(@"出错了%@",error);
            return ;
        }
        NSDictionary *dict = (id)responseObject;
        NSDictionary *arrayDict = dict[@"data"];
        
        //解析focus字典,并转换成模型存到focusArray数组中
        NSArray *arrFocus = arrayDict[@"focus"];
        NSMutableArray *focusArray = [NSMutableArray new];
        for (NSDictionary *dict in arrFocus) {
            BQCommonModel *model = [BQCommonModel new];
            
            [model setValuesForKeysWithDictionary:dict];
            [focusArray addObject:model];
        }
        self.focusArray = focusArray.copy;
        
        //解析icons字典,并转换成模型存到iconsArray数组中
        NSArray *arrIcons = arrayDict[@"icons"];
        NSMutableArray *iconsArray = [NSMutableArray new];
        for (NSDictionary *dict in arrIcons) {
            BQCommonModel *model = [BQCommonModel new];
            
            [model setValuesForKeysWithDictionary:dict];
            [iconsArray addObject:model];
        }
        self.iconsArray = iconsArray.copy;
        
        //解析activities字典,并转换成模型存到activiessArray数组中
        NSArray *arrActivities = arrayDict[@"activities"];
        NSMutableArray *activitiesArray = [NSMutableArray new];
        for (NSDictionary *dict in arrActivities) {
            BQCommonModel *model = [BQCommonModel new];
            
            [model setValuesForKeysWithDictionary:dict];
            [activitiesArray addObject:model];
        }
        self.activitiesArray = activitiesArray.copy;
        
        
        [self getimgFocusURLArr];
        [self getimgActivitiesURLArr];
        [self geticonstoURLArr];
        [self getactiviestoURLArr];
        
        NSDictionary *info = @{@"info":self};
        

        [[NSNotificationCenter defaultCenter]postNotificationName:@"DOWNLOADCOMPLETE" object:nil userInfo:info];

        
    }];

    
}


-(void)getDetailInfoWithCompleteBlock:(void (^)(NSArray<BQProduct *> *))completeBlock{
    NSDictionary *parame = @{@"call":@(2)};
    
    [[BQNetWorkTools sharedTools]requestWithMethodType:POST urlString:@"http://iosapi.itcast.cn/loveBeen/firstSell.json.php" parameters:parame finishedCallBackBlock:^(id responseObject, NSError *error) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *dict in array) {
            BQProduct *detailModel  = [BQProduct yy_modelWithDictionary:dict];
            
            [arrM addObject:detailModel];
        }
        
        completeBlock(arrM.copy);
    }];

}



- (void)getimgFocusURLArr{
    
    NSMutableArray *imgURLs = [NSMutableArray new];
    for (BQCommonModel *model in self.focusArray) {
        [imgURLs addObject:model.img];
    }
    self.focusImgURLs = imgURLs.copy;
    
}
- (void)getimgActivitiesURLArr{
    
    NSMutableArray *imgURLs = [NSMutableArray new];
    for (BQCommonModel *model in self.activitiesArray) {
        NSURL *url = [NSURL URLWithString:model.img];
        [imgURLs addObject:url];
    }
    self.activiesImgURLs = imgURLs.copy;
    
}
- (void)geticonstoURLArr{
    
    NSMutableArray *imgURLs = [NSMutableArray new];
    for (BQCommonModel *model in self.iconsArray) {
        NSURL *url = [NSURL URLWithString:model.customURL];
        [imgURLs addObject:url];
    }
    self.iconstoURLs = imgURLs.copy;
    
}
- (void)getactiviestoURLArr{
    
    NSMutableArray *urls = [NSMutableArray new];
    for (BQCommonModel *model in self.activitiesArray) {
        NSURL *url = [NSURL URLWithString:model.customURL];
        [urls addObject:url];
    }
    self.activiestoURLs = urls.copy;
    
}
@end
