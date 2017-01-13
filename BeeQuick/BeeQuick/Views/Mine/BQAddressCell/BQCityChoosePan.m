//
//  BQCityChoosePan.m
//  BeeQuick
//
//  Created by 王林 on 2016/12/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQCityChoosePan.h"

@interface BQCityChoosePan ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *cityPickerView;

@property(nonatomic,strong)NSArray *cityArray;

@end

@implementation BQCityChoosePan

+ (instancetype)cityPickerPan {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"BQCityChoosePan" owner:nil options:nil] lastObject];
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.cityPickerView.delegate = self;
    self.cityPickerView.dataSource = self;
    
    self.cityArray =  @[@"北京市", @"上海市", @"天津市", @"广州市", @"佛山市", @"深圳市", @"廊坊市", @"武汉市", @"苏州市", @"无锡市"];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.cityArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.cityArray[row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectedCity = self.cityArray[row];
}

@end
