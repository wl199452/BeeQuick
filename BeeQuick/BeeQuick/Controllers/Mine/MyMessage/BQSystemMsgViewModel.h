//
//  BQSystemMsgViewModel.h
//  BeeQuick
//
//  Created by 郭选 on 2016/12/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BQSystemModel;

@interface BQSystemMsgViewModel : NSObject

@property(nonatomic,strong)NSMutableArray<BQSystemModel*> *modelList;

- (void)loadData:(void(^)(BOOL isSuccess))finish;


@end
