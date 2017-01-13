//  JQSystemViewCell.h
//  BeeQuick
//
//  Created by 郭选 on 2016/12/27.
//  Copyright © 2016年 Mac. All rights reserved.
//
#import <UIKit/UIKit.h>

@class BQSystemModel;

typedef void(^Block_ReloadTableView)(BQSystemModel*,NSInteger);

@interface JQMessageTitleCell : UITableViewCell

@property(nonatomic,strong)BQSystemModel *model;

@property (nonatomic, copy)Block_ReloadTableView block_ReloadTableView;

@property (weak, nonatomic) IBOutlet UIButton *showBtn;


@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
