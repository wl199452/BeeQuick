//
//  BQCategoryCell.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQCategoryCell.h"
#import <Masonry.h>

@interface BQCategoryCell ()
@property(nonatomic,weak)UIView *yellowView;

@end

@implementation BQCategoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *yellowView = [[UIView alloc]init];
        [self.contentView addSubview:yellowView];
       
        _yellowView = yellowView;
        
        [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.width.mas_equalTo(4);
            make.height.equalTo(self.contentView).multipliedBy(0.8);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    else{
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

    }
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
//    UIView *bgView = [UIView new];
//    bgView.backgroundColor = [UIColor redColor];
//    
//    UIView *selBGview = [UIView  new];
//    selBGview.backgroundColor = [UIColor blueColor];
    
    if (selected) {
//        self.selectedBackgroundView = selBGview;
        self.yellowView.backgroundColor = kMainColor;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    else{
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//        self.backgroundView = bgView;
        
         self.yellowView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
}



@end
