//
//  BQHomeModel.h
//  BeeQuick
//
//  Created by 风不会停息 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@class BQCommonModel;
@class BQProduct;
@interface BQHomeModel : NSObject



@property (nonatomic,strong)NSArray <BQCommonModel *> *focusArray;

@property (nonatomic,strong)NSArray <BQCommonModel *> *iconsArray;

@property (nonatomic,strong)NSArray <BQCommonModel *> *activitiesArray;


//focus的image的url数组
@property (nonatomic,strong)NSArray <NSString *>*focusImgURLs;

//activities的 image的url数组
@property (nonatomic,strong)NSArray <NSURL *>*activiesImgURLs;

//icon跳转的url数组
@property (nonatomic,strong)NSArray <NSURL *>*iconstoURLs;

//activities的url数组

@property (nonatomic,strong)NSArray <NSURL *>*activiestoURLs;

//详情页的数据

-(void)getDetailInfoWithCompleteBlock:(void(^)(NSArray<BQProduct *>*detailsArray))completeBlock;


@end
