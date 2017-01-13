//
//  BQSuggestView.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQSuggestView.h"

@interface BQSuggestView()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textNumber_text;

@property (weak, nonatomic) IBOutlet UITextView *suggest_text;

@property(nonatomic,strong) UILabel *placeHolderLabel;

@end



@implementation BQSuggestView

+ (instancetype)loadsuggestView
{
    return [[[UINib nibWithNibName:@"BQSuggestView" bundle:nil]instantiateWithOwner:nil options:nil]lastObject];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.suggest_text.delegate = self;
    
    self.placeHolderLabel = [[UILabel alloc]init];
    
    self.placeHolderLabel.text = @"请输入宝贵意见";
    
    self.placeHolderLabel.font = [UIFont systemFontOfSize:15];
    
    self.placeHolderLabel.textColor = [UIColor lightGrayColor];
    
    [self.suggest_text addSubview:self.placeHolderLabel];
    
    
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.suggest_text).offset(8);
        
        make.left.equalTo(self.suggest_text).offset(5);
        
    }];

}


#pragma mark
#pragma mark - 代理
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeHolderLabel.hidden = self.suggest_text.hasText;
    NSInteger number = [self.suggest_text.text length];
    
    if (number > 200) {
        
        self.suggest_text.text = [self.suggest_text.text substringToIndex:200];
        
        number = 200;
    }
    
    self.textNumber_text.text = [NSString stringWithFormat:@"%zd",200 - number];
}

@end
