//
//  BQMyReceiveAddressModel.m
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQMyReceiveAddressModel.h"
#import "BQNetWorkTools.h"
#import <YYModel.h>

@implementation BQMyReceiveAddressModel


-(instancetype)init{
    if (self = [super init]) {
     
    }
    return self;
}


- (void)loadAddressDataWithCompleteBlock:(void (^)(NSArray <BQAddressModel *> *))completeBlock {
    
    //查看文件是否存在
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"addressBook.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray *addArray = [BQAddressModel unarchiver];
        if (addArray.count) {
            completeBlock(addArray);
            return;
        }
    }

    NSDictionary *parameters = @{@"call":@(12)};
    [[BQNetWorkTools sharedTools]requestWithMethodType:POST urlString:@"http://iosapi.itcast.cn/loveBeen/MyAdress.json.php" parameters:parameters finishedCallBackBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error != nil) {
            NSLog(@"获取网络数据出错啦  %@",error);
            return ;
        }

        NSArray *arrayModel = responseObject[@"data"];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict in arrayModel) {
                
            BQAddressModel *model = [BQAddressModel yy_modelWithDictionary:dict];
            [arrayM addObject:model];
        }
        //归档
        [BQAddressModel archiver:arrayM.copy];
        
        completeBlock(arrayM.copy);
        
    }];

}

@end
