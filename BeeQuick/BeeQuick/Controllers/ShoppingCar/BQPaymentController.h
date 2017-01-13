//
//  BQPaymentController.h
//  BeeQuick
//
//  Created by Mac on 16/12/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQBaseViewController.h"

@protocol BQPaymentControllerDelegate <NSObject>

- (void)paymentSuccessed;

@end

@interface BQPaymentController : UIViewController

@property (nonatomic, strong) NSArray<BQProduct *> *productArray;

@property (nonatomic, weak) id<BQPaymentControllerDelegate> delegate;

@end
