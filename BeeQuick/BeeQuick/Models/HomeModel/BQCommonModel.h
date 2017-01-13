//
//  BQCommonModel.h
//  BeeQuick
//
//  Created by 风不会停息 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQCommonModel : NSObject

//Focus icons activitives数据模型相似,所以用一个通用的模型

@property (nonatomic,copy)NSString *idNum;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *img;

@property (nonatomic,copy)NSString *toURL;

@property (nonatomic,copy)NSString *customURL;

@end
