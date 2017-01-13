//
//  BQOrderViewModel.h
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BQOrderCellViewModel;

@class BQOrderDetailModel;

@interface BQOrderViewModel : NSObject

@property(nonatomic,strong)NSArray <BQOrderCellViewModel*>* viewmodelArray;

@property(nonatomic,strong)NSArray <BQOrderDetailModel *> *viewMODELlArray;


- (void)loadData:(void(^)(BOOL isSuccess))finish;

+ (instancetype)sharedOrderViewModel;

@end
