//
//  BQActiviesCell.m
//  BeeQuick
//
//  Created by 风不会停息 on 2016/12/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQActivitiesCell.h"
#import "BQCommonModel.h"
#import <UIButton+WebCache.h>


@interface BQActivitiesCell ()

@property (nonatomic,strong) NSMutableArray<UIButton *> *btnArr;

@property (nonatomic,strong) NSMutableArray<NSURL *> *urlArr;


@end

@implementation BQActivitiesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
        
    {
        [self setUI];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kClearColor;
    }
    
    return self;
    
}

- (void)setModel:(BQHomeModel *)model{
   
    _model = model;
    NSMutableArray <NSURL *>*arr = [NSMutableArray array];
    
    for (int i = 0;i<model.activitiesArray.count;i++){
        
        BQCommonModel *common = model.activitiesArray[i];
        
        NSURL *url = [NSURL URLWithString:common.img];
        
        [arr addObject:url];
        
    }
    
    self.urlArr = arr;

    
    for (int i =0; i<model.iconsArray.count; i++) {
        [_btnArr[i] sd_setImageWithURL:self.urlArr[i] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"v2_placeholder_full_size"]];
    }
    
}

- (void)setUI{
    
    CGFloat btnHeight = 130;
    CGFloat margin = 5;
    
    NSMutableArray *btnArr = [NSMutableArray new];
    
    for (int i =0 ; i<4; i++) {//_model.activitiesArray.count
        
        CGFloat btnY = i *(btnHeight+margin*2);
        
        UIButton *btn = [UIButton buttonWithType:0];
        btn.tag = i;
        [btn setFrame:CGRectMake(margin*2, btnY+margin*2, SCREEN_WIDTH-4*margin, btnHeight)];
        
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [btn sd_setImageWithURL:self.model.activiesImgURLs[i] forState:UIControlStateNormal];
        [btnArr addObject:btn];
        
        [self.contentView addSubview:btn];
    }
    _btnArr = btnArr;
    
    
}
- (void)btnClick:(UIButton *)sender{
    

    switch (sender.tag) {
        case 0:
            if (self.model != nil) {
                [self.delegate jumptoURL:self.model.activiestoURLs[0]];
            }
            
            break;
        case 1:
            if (self.model != nil) {
                [self.delegate jumptoURL:self.model.activiestoURLs[1]];
            }
            break;
        case 2:
            if (self.model != nil) {
                [self.delegate jumptoURL:self.model.activiestoURLs[2]];
            }
            break;
        case 3:
            if (self.model != nil) {
                [self.delegate jumptoURL:self.model.activiestoURLs[3]];
            }
            break;
        default:
            break;
    }

    
}
@end
