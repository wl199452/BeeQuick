//
//  BQGoodsInfoModes.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQGoodsInfoModes.h"
#import "BQNetWorkTools.h"
#import <YYModel.h>
#import "BQCategroy.h"
#import "BQProduct.h"
#import <SVProgressHUD.h>


@interface BQGoodsInfoModes ()
@property(nonatomic,strong)NSMutableArray<BQCategroy *> *categroyArr;
@property(nonatomic,strong)NSMutableArray<BQProduct *> *productArr;

//文件路径
//@property(nonatomic,strong)NSString *resourcePath;
@end


@implementation BQGoodsInfoModes




- (void)getCategeroyInfoCompleteBlock:(void(^)(NSArray<BQCategroy *>* categroyRes))completeBlock{
    
    [SVProgressHUD showErrorWithStatus:@"loading...👽"];
    
    NSString *urlString = @"http://iosapi.itcast.cn/loveBeen/supermarket.json.php";
    NSDictionary *parameters = @{@"call":@"5"};
    
    _categroyArr = [NSMutableArray array];
    _productArr = [NSMutableArray array];
    
    NSString *resourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"BeeQuikData.plist"];
    // 文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSDictionary *dic1 = [manager attributesOfItemAtPath:resourcePath error:nil];
    id leng =  dic1[@"NSFileSize"];
    
#pragma mark --
#pragma mark - 判断本地是否有缓存,如果本地没有文件则需要网络获取并存储本地
    if (leng == nil) {
        
        [[BQNetWorkTools sharedTools ] requestWithMethodType:POST urlString:urlString parameters:parameters finishedCallBackBlock:^(id responseObject, NSError *error) {
            if (error != nil) {
                return ;
            }
            //成功
            [responseObject writeToFile:resourcePath atomically:YES];
            
            NSArray *categroys = responseObject[@"data"][@"categories"];
            NSDictionary *products = responseObject[@"data"][@"products"];
            
            for (NSDictionary *categroy in categroys) {
                BQCategroy *cat =  [BQCategroy  yy_modelWithDictionary:categroy];
                cat.productArr = [NSMutableArray array];
                
                NSArray *dict = products[cat.cid];
                
                for (NSDictionary *product in dict) {
                    BQProduct *pro = [BQProduct yy_modelWithDictionary:product];
                    [_productArr addObject:pro];
                    
                    [cat.productArr addObject:pro];
                }
                
                [_categroyArr addObject:cat];
                
            }
            completeBlock(_categroyArr.copy);
            
        }];
    }
    
#pragma mark --
#pragma mark -本地有缓存则直接读取数据
    else{
        
        NSString *resourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"BeeQuikData.plist"];
        
        NSDictionary *response = [NSDictionary dictionaryWithContentsOfFile:resourcePath];
        
        NSArray *categroys = response[@"data"][@"categories"];
        
        NSDictionary *products = response[@"data"][@"products"];
        
        for (NSDictionary *categroy in categroys) {
            BQCategroy *cat =  [BQCategroy  yy_modelWithDictionary:categroy];
            cat.productArr = [NSMutableArray array];
            
            NSArray *dict = products[cat.cid];
            
            for (NSDictionary *product in dict) {
                BQProduct *pro = [BQProduct yy_modelWithDictionary:product];
                [_productArr addObject:pro];
                
                [cat.productArr addObject:pro];
            }
            
            [_categroyArr addObject:cat];
            
        }
        
        completeBlock(_categroyArr.copy);
        
        
    }
    
    
}



@end
