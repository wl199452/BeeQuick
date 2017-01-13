//
//  BQHomeDetailCell.h
//  BeeQuick
//
//  Created by 王林 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//




#import <UIKit/UIKit.h>
@class BQProduct;

@interface BQHomeDetailCell : UITableViewCell

@property(nonatomic,strong)BQProduct *leftModel;

@property(nonatomic,strong)BQProduct *rightModel;




@end
