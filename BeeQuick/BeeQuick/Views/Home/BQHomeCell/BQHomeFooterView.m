//
//  BQHomeFooterView.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQHomeFooterView.h"

@implementation BQHomeFooterView

+(instancetype)homeFooterView{
    return [[[NSBundle mainBundle]loadNibNamed:@"BQHomeFooterView" owner:nil options:nil] lastObject];
}
- (IBAction)clickMoreInfo:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:HomeFooterViewClickMoreBtnNotifacation object:self];
}

@end
