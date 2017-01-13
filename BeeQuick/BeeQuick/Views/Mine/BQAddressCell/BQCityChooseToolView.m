//
//  BQCityChooseToolView.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQCityChooseToolView.h"

@interface BQCityChooseToolView ()

@end

@implementation BQCityChooseToolView

+ (instancetype)cityChooseToolView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"BQCityChooseToolView" owner:nil options:nil] lastObject];
}
- (IBAction)chooseCancel:(UIButton *)sender {
    
    if (self.cityChooseToolViewCancelBlock) {
        self.cityChooseToolViewCancelBlock();
    }
}

- (IBAction)chooseCommit:(UIButton *)sender {
    if (self.cityChooseToolViewCommitBlock) {
        self.cityChooseToolViewCommitBlock();
    }
}



@end
