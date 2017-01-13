//
//  BQCityChooseToolView.h
//  BeeQuick
//
//  Created by 王林 on 2016/12/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BQCityChooseToolView : UIView

+ (instancetype)cityChooseToolView;

@property (nonatomic, copy) void(^cityChooseToolViewCancelBlock)();
@property (nonatomic, copy) void(^cityChooseToolViewCommitBlock)();

@end
