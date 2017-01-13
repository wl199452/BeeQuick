//
//  BQActiviesCell.h
//  BeeQuick
//
//  Created by 风不会停息 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQHomeModel.h"
#import "BQHomeJumpDelegate.h"

@interface BQActivitiesCell : UITableViewCell

@property (nonatomic,weak)id<BQHomeJumpDelegate>delegate;

@property (nonatomic,strong)BQHomeModel *model;

@end
