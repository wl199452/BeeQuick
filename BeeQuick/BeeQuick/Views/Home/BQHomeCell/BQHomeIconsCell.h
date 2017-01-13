//
//  BQIconsCellTableViewCell.h
//  BeeQuick
//
//  Created by 风不会停息 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BQHomeJumpDelegate.h"


@class BQHomeModel;

@interface BQHomeIconsCell : UITableViewCell

@property (nonatomic,strong)BQHomeModel *model;

@property (nonatomic,weak)id<BQHomeJumpDelegate>delegate;


@end
