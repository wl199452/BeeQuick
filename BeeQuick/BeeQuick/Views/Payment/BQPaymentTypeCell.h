//
//  BQPaymentTypeCell.h
//  BeeQuick
//
//  Created by Mac on 16/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQPaymentTypeCell : UITableViewCell

@property (nonatomic, strong) UIImage *paymentTypeIamge;

@property (nonatomic, copy) NSString *paymentTypeTitle;

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;


@end
