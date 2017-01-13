//
//  BQOrderIDCell.h
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQOrderStateCell.h"
#import "BQStatusModel.h"


@interface BQOrderStateCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *yellowBtn;

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end


@implementation BQOrderStateCell


- (void)setModel:(BQStatusModel *)model {
    
    _model = model;
    
    self.timeLabel.text = model.status_time;
    
    [self.titleBtn setTitle:model.status_title forState:UIControlStateNormal];
    
    self.descLabel.text = model.status_desc;
    
    if ([model.status_desc containsString:@"下单成功"]) {
        
        NSRange range = [model.status_desc rangeOfString:@"订单号"];
        
        NSString *before = [model.status_desc substringToIndex:range.location + 4];
        
        NSString *after = [model.status_desc substringFromIndex:range.location + 4];
        
        
        self.descLabel.text = [NSString stringWithFormat:@"%@\n%@",before,after];
        
        self.bottomView.hidden = YES;
        
    } else {
        
        self.bottomView.hidden = NO;
        
    }
    
    
    if ([model.status_title isEqualToString:@"已完成"]) {
        
        self.topView.hidden = YES;
        
        self.yellowBtn.selected = YES;
        
        self.titleBtn.selected = YES;
        
    }else {
        
        self.topView.hidden = NO;
        
        self.yellowBtn.selected = NO;
        
        self.titleBtn.selected = NO;
    }
    
    
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}


@end
