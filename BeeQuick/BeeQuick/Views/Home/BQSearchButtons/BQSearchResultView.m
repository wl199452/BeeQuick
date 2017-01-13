//
//  BQSearchResultView.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQSearchResultView.h"


@interface BQSearchResultView ()

//搜索信息
@property (weak, nonatomic) IBOutlet UILabel *lbl_Text;

@end


@implementation BQSearchResultView

+(instancetype)searchResultView{
    return [[[NSBundle mainBundle]loadNibNamed:@"BQSearchResultView" owner:self options:nil] lastObject];
}

-(void)setSearchInfo:(NSString *)searchInfo{
    _searchInfo = searchInfo;
    
    NSLog(@"%@",searchInfo);
    self.lbl_Text.text = [NSString stringWithFormat:@"暂时没有搜到\"%@\"相关商品",searchInfo];
}


@end
