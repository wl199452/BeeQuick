//
//  BQPaymentCommitView.h
//  BeeQuick
//
//  Created by Mac on 16/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BQPaymentCommitViewDelegate <NSObject>

- (void)commitPayment;

@end

@interface BQPaymentCommitView : UIView

+ (instancetype)paymentCommitView;

@property (nonatomic, assign) float totalPrice;

@property (nonatomic, weak) id<BQPaymentCommitViewDelegate> delegate;

@end
