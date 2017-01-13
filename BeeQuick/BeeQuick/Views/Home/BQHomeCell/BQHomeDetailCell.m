//
//  BQHomeDetailCell.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//



#import "BQHomeDetailCell.h"
#import "BQHomeDetailCellView.h"
#import "BQProduct.h"



@interface BQHomeDetailCell ()
@property(nonatomic,strong)NSMutableArray<UIView*>*viewArr ;
@property(nonatomic,strong)BQHomeDetailCellView *left_cellView ;

@property(nonatomic,strong)BQHomeDetailCellView *right_cellView;
@end


@implementation BQHomeDetailCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat margin = 8;
        CGFloat W = (SCREEN_WIDTH - 3 * margin) / 2;


        BQHomeDetailCellView *left_cellView = [BQHomeDetailCellView  homeDetailCellView];
        _left_cellView = left_cellView;
        
        [_left_cellView layoutIfNeeded];
    
       
        
        [self.contentView addSubview:left_cellView];

        [left_cellView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.leading.equalTo(self.contentView).mas_offset(margin);
            make.top.mas_equalTo(self.contentView).mas_offset(margin);
            make.width.mas_equalTo(W);
            make.height.mas_equalTo(W).multipliedBy(1.2);
            
            make.bottom.mas_equalTo(self.contentView);
        }];
        
      
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCellView:)];
        
        [left_cellView addGestureRecognizer:tap];
        
        
         BQHomeDetailCellView *right_cellView = [BQHomeDetailCellView  homeDetailCellView];
        _right_cellView = right_cellView;
        
          [_right_cellView layoutIfNeeded];
        
        [self.contentView addSubview:right_cellView];
     
        
        right_cellView.productModel = self.rightModel;
        [right_cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(margin);
            make.trailing.equalTo(self.contentView).mas_offset(-margin);
             make.width.mas_equalTo(W);
            make.height.mas_equalTo(W).multipliedBy(1.2);
            make.bottom.mas_equalTo(self.contentView);
        }];
      
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCellView:)];
        
        [right_cellView addGestureRecognizer:tap1];
        
        
    }
    
    return self;
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
     CGFloat leftHeight = CGRectGetMaxY(_left_cellView.lbl_Partner_price.frame);
    [_left_cellView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(leftHeight);
        
    }];
    
     CGFloat rightHeight = CGRectGetMaxY(_right_cellView.lbl_Partner_price.frame);
    [_right_cellView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(rightHeight);
    }];
    
}



-(void)setLeftModel:(BQProduct *)leftModel{
    _leftModel = leftModel;

    self.left_cellView.productModel = leftModel;
}

-(void)setRightModel:(BQProduct *)rightModel{
    _rightModel = rightModel;
    
    self.right_cellView.productModel = rightModel;
}


-(void)clickCellView:(UITapGestureRecognizer *)tap{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:BeeQuickClickCellJumpNotifacation object:self userInfo:@{kCellView:tap.view}];
    

}








@end
