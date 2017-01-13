//
//  BQReceiveAddressCell.h
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQAddressModel.h"
@interface BQReceiveAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *editAddressBtn;
@property(copy,nonatomic)BQAddressModel *addressModel;
/*
 编辑按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end
