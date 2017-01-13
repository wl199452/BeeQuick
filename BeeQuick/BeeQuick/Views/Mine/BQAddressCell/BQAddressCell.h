//
//  BQAddressCell.h
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQAddressModel.h"
@interface BQAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (weak, nonatomic) IBOutlet UITextField *contactsTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextF;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

@property(strong,nonatomic)BQAddressModel *infoModel;

@end
