//
//  BQOrderDetailViewController.h
//  BeeQuick
//
//  Created by 郭选 on 2016/12/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQBaseViewController.h"

@class BQOrderCellViewModel;

@class BQStatusModel;

@class BQOrderDetailModel;

@interface BQOrderDetailViewController :UIViewController

@property(nonatomic,strong)NSArray <BQStatusModel*> *statusModelList;

@property(nonatomic,strong)BQOrderCellViewModel *detailModel;

//@property(nonatomic,strong) BQOrderDetailModel *orderDetalModel;

//@property(nonatomic,strong)NSArray <BQOrderDetailModel *> *orderDetalModel;

@end
