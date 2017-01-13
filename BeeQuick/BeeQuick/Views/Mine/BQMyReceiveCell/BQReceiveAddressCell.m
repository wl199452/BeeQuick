//
//  BQReceiveAddressCell.m
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQReceiveAddressCell.h"

@implementation BQReceiveAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}

-(void)setAddressModel:(BQAddressModel *)addressModel{
     _addressModel = addressModel;
    self.nameLabel.text = addressModel.accept_name;
    self.telNumLabel.text = addressModel.telphone;
    self.addressLabel.text = addressModel.address;
    
}
@end
