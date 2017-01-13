//  JQSystemViewCell.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "JQMessageTitleCell.h"
#import "BQSystemModel.h"

@interface JQMessageTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation JQMessageTitleCell

- (IBAction)showAll:(UIButton *)sender {
    
    if (self.block_ReloadTableView) {
        
        self.model.isShowAll = !self.model.isShowAll;
        
        self.block_ReloadTableView(self.model,sender.tag);
    }
    
}

- (void)setModel:(BQSystemModel *)model {
    
    _model = model;
    
    self.titleLabel.text = model.title;
    
    self.contentLabel.text = model.content;
    
    self.contentLabel.numberOfLines = model.isShowAll ? 0 : 2;
    
    CGFloat twoRowHeight = [self heightForString:@"\n\n" fontSize:12 andWidth:SCREEN_WIDTH - 40];
    
    CGFloat realHeight = [self heightForString:model.content fontSize:12 andWidth:SCREEN_WIDTH - 40];
    
    //多于两行,显示按钮
    self.showBtn.hidden = realHeight < twoRowHeight;
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 40;
      
}
//根据字体和宽度计算高度
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    
    detailLabel.font = [UIFont systemFontOfSize:fontSize];
    
    detailLabel.text = value;
    
    detailLabel.numberOfLines = 0;
    
    [detailLabel sizeToFit];
    
    return detailLabel.bounds.size.height;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}



@end
