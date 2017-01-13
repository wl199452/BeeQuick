//
//  BQOrderViewModel.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQOrderViewModel.h"
#import "BQNetWorkTools.h"
#import "BQOrderDetailModel.h"
#import "BQOrderGoodsModel.h"
#import "BQOrderCellViewModel.h"

@interface BQOrderViewModel ()

@end

@implementation BQOrderViewModel

static id _instance;

+ (instancetype)sharedOrderViewModel {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc]init];
    });
    return _instance;
}


- (NSArray<BQOrderCellViewModel *> *)viewmodelArray {
    
    if (!_viewmodelArray) {
        
        _viewmodelArray = [NSArray array];
    }
    
    return _viewmodelArray;
    
}

- (void)loadData:(void(^)(BOOL isSuccess))finish {
    
    //我的订单数据
    NSString *urlString = @"http://iosapi.itcast.cn/loveBeen/MyOrders.json.php";
    
    NSDictionary *parameters = @{@"call":@"13"};
    
    [[BQNetWorkTools sharedTools]requestWithMethodType:POST urlString:urlString parameters:parameters finishedCallBackBlock:^(id responseObject, NSError *error) {
        
        if (error) {
            
            finish(NO);
            
        }
        
        //NSLog(@"%@",responseObject);
        
        NSArray *dataArr = responseObject[@"data"];
        
        NSArray *arrDetail = [NSArray yy_modelArrayWithClass:[BQOrderDetailModel class] json:dataArr];
        
        NSMutableArray *goods_2 = [NSMutableArray array];
        
        for (NSDictionary *dict in dataArr) {
            
            NSMutableArray *goods_1 = [NSMutableArray array];
            
            NSArray *order_goods = dict[@"order_goods"];
            
            for (NSArray *array in order_goods) {
                
                NSMutableArray *goods = [NSMutableArray array];
                
                for (NSDictionary *dictMin in array) {
                    
                    BQOrderGoodsModel *good = [[BQOrderGoodsModel alloc]init];
                    
                    [good setValuesForKeysWithDictionary:dictMin];
                    
                    [goods addObject:good];
                }
                
                [goods_1 addObject:goods.copy];
            }
            
            [goods_2 addObject:goods_1];
            
        }
        
        for (int i = 0; i < dataArr.count; i++) {
            
            BQOrderDetailModel *model = arrDetail[i];
            
            model.order_goods = goods_2[i];
        }
        
        NSMutableArray *arrTemp = [NSMutableArray array];
        
        for (BQOrderDetailModel *detailModel in arrDetail.copy) {
            
            BQOrderCellViewModel *cellViewModel = [[BQOrderCellViewModel alloc]init];
            
            cellViewModel.model = detailModel;
            
            [arrTemp addObject:cellViewModel];
        }
        
        self.viewmodelArray = arrTemp.copy;
        
        finish(YES);
        
    }];
}
@end
