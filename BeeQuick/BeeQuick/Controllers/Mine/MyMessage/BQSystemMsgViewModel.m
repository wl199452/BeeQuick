//
//  BQSystemMsgViewModel.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQSystemMsgViewModel.h"
#import "BQSystemModel.h"
#import "BQNetWorkTools.h"

@implementation BQSystemMsgViewModel

- (NSMutableArray<BQSystemModel *> *)modelList {
    
    if (!_modelList) {
        
        _modelList = [NSMutableArray array];
    }
    return _modelList;
    
}



- (void)loadData:(void(^)(BOOL isSuccess))finish {
    
    //我的订单数据
    NSString *urlString = @"http://iosapi.itcast.cn/loveBeen/SystemMessage.json.php";
    
    NSDictionary *parameters = @{@"call":@"10"};
    
    
    [[BQNetWorkTools sharedTools]requestWithMethodType:POST urlString:urlString parameters:parameters finishedCallBackBlock:^(id responseObject, NSError *error) {
        
        if (error) {
            
            finish(NO);
        }
        
        self.modelList = [NSMutableArray yy_modelArrayWithClass:[BQSystemModel class] json:responseObject[@"data"]];
        
        
        finish(YES);
        
    }];
    
}



@end
