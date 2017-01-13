//
//  BQOrderIDCell.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQOrderIDCell.h"
#import "BQOrderDetailModel.h"

@interface BQOrderIDCell()

@property (weak, nonatomic) IBOutlet UILabel *accpect_people;

@property (weak, nonatomic) IBOutlet UILabel *accept_address;

@property (weak, nonatomic) IBOutlet UILabel *accept_shop;

@property (weak, nonatomic) IBOutlet UILabel *accept_phone;
@end

@implementation BQOrderIDCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

-(void)setViewDEModel:(BQOrderDetailModel *)viewDEModel

{
    _viewDEModel = viewDEModel;
    
    self.accpect_people.text = viewDEModel.accept_name;
    
    self.accept_address.text = viewDEModel.address;
    
    self.accept_shop.text = viewDEModel.dealer_name;
    
    self.accpect_people.text = viewDEModel.telphone;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.font = [UIFont systemFontOfSize:12];
        
        self.textLabel.textColor = [UIColor grayColor];
        
    }
    
    return self;
    
}
- (IBAction)collectBtn:(UIButton *)sender {
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collect"object:nil];
    
}




@end
