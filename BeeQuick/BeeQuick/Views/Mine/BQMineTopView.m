//
//  BQMineTopView.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQMineTopView.h"
#import "BQSetController.h"
@interface BQMineTopView()

@property (weak, nonatomic) IBOutlet UIButton *icon_image;

@property (weak, nonatomic) IBOutlet UILabel *PhoneNum_lbl;

@end


@implementation BQMineTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

- (IBAction)Setting_Btn:(UIButton *)sender
{
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mytest"object:nil];
    
}
@end
