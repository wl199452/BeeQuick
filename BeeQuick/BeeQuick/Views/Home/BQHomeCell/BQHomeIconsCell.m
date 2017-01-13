//
//  BQIconsCellTableViewCell.m
//  BeeQuick
//
//  Created by 风不会停息 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQHomeIconsCell.h"
#import "BQHomeModel.h"
#import "BQCommonModel.h"
#import <UIButton+WebCache.h>
#import <Masonry.h>
#import "NSAttributedString+ZFBAdditon.h"
//#import <UIImageView+WebCache.h>
@interface BQHomeIconsCell ()


@property (nonatomic,strong) NSMutableArray<NSURL *> *urlArr;

@property (nonatomic,strong) NSMutableArray<UIButton *> *btnArr;

@end

@implementation BQHomeIconsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self) {
        
        
        [self setBtn];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void) setBtn{
    CGFloat btnHeight = 50;
    CGFloat btnWidth = 70;
    CGFloat Margin = (SCREEN_WIDTH - 4 *btnWidth)/4;
    CGFloat EdgeMargin = Margin/2;
    
    NSMutableArray *btnArr = [NSMutableArray new];
    
//    NSAttributedString *str = [NSAttributedString cz_imageTextWithImage:<#(UIImage *)#> imageW:<#(CGFloat)#> imageH:<#(CGFloat)#> title:(NSString *) fontSize:<#(CGFloat)#> titleColor:<#(UIColor *)#> spacing:<#(CGFloat)#>]
    
    NSArray *labelArr = @[@"抽 奖",@"秒 杀",@"抢红包",@"蜂抱团"];
    
    for (int i = 0; i< 4; i++) {
        CGFloat btnX = EdgeMargin + i *(btnWidth + Margin);
        CGFloat btnY =(self.frame.size.height - btnHeight)/2+15;
        UIButton *btn = [UIButton buttonWithType:0];
        [btn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setFrame:CGRectMake(btnX, btnY, btnWidth, btnHeight)];
        
        
        btn.tag = i;
        
        [btnArr addObject:btn];
        [self.contentView addSubview:btn];
        

        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
        
        label.center = CGPointMake(btn.center.x, btn.center.y + btnHeight/2+10);
        
        label.font = [UIFont boldSystemFontOfSize:12];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        
        label.text = labelArr[i];
        
        [self addSubview:label];
        
        
    }
    _btnArr = btnArr;

}



- (void)setModel:(BQHomeModel *)model{
    _model = model;
   
    NSMutableArray <NSURL *>*arr = [NSMutableArray array];
    
    for (int i = 0;i<model.iconsArray.count;i++){
        
        BQCommonModel *common = model.iconsArray[i];
        
        NSURL *url = [NSURL URLWithString:common.img];
        
        [arr addObject:url];
        
    }
    
    self.urlArr = arr;
    //[self setBtn];
    
    for (int i =0; i<model.iconsArray.count; i++) {
        [_btnArr[i] sd_setImageWithURL:self.urlArr[i] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"v2_placeholder_square"]];
        
    }

    
    
}
- (void)btnCLick:(UIButton *)sender{
    

    switch (sender.tag) {
        case 0:
            if (self.model != nil) {
                [self.delegate jumptoURL:self.model.iconstoURLs[0]];
            }
            
            break;
        case 1:
            if (self.model != nil) {
                [self.delegate jumptoURL:self.model.iconstoURLs[1]];
            }
            break;
        case 2:
            if (self.model != nil) {
                [self.delegate jumptoURL:self.model.iconstoURLs[2]];
            }
            break;
        case 3:
            if (self.model != nil) {
                [self.delegate jumptoURL:self.model.iconstoURLs[3]];
            }
            break;
        default:
            break;
    }

    
}





@end
