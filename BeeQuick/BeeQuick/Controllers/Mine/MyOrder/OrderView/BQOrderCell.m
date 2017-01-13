//
//  BQOrderCell.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//


#import "BQOrderCell.h"
#import "BQOrderCellViewModel.h"
#import <UIImageView+WebCache.h>

@interface BQOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *creatTime_label;

@property (weak, nonatomic) IBOutlet UILabel *buyNum_label;

@property (weak, nonatomic) IBOutlet UILabel *userPay_label;


@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageS;


@end


@implementation BQOrderCell



- (void)setViewModel:(BQOrderCellViewModel *)viewModel {
    
    _viewModel = viewModel;
    
    self.creatTime_label.text = viewModel.create_time;
    
    self.buyNum_label.text = viewModel.buyNumStr;
    
    self.userPay_label.text = viewModel.userBuyStr;
    
    
//    for (UIImageView *imageView in self.imageS) {
//        
//        imageView.image = nil;
//    }
    
    if (viewModel.imageUrls.count > 4) {
        
        for (int i = 0; i < 4; i++) {
            
            UIImageView *imageView = self.imageS[i];
            
            NSURL *url = viewModel.imageUrls[i];
            
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"author"]];
            
        }
        
        UIImageView *imageView = self.imageS[4];
        
        imageView.image = [UIImage imageNamed:@"v2_goodmore"];
        
    } else {
        
        for (int i = 0; i < viewModel.imageUrls.count; i ++) {
            
            UIImageView *imageView = self.imageS[i];
            
            NSURL *url = viewModel.imageUrls[i];
            
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"author"]];
        }
    }
    
    
    
}



@end
