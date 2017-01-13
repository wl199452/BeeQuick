//
//  BQAddressCell.m
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQAddressCell.h"
#import "BQCityChoosePan.h"
#import "BQCityChooseToolView.h"

@interface BQAddressCell ()<UITextFieldDelegate>

@property (nonatomic, strong) BQCityChoosePan *cityChoosePan;
@property (nonatomic, strong) BQCityChooseToolView *cityChooseToolView;

@end



@implementation BQAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.phoneNumTextField.delegate = self;

    [self setupCityPickerView];
    
    [self setupCityPickerToolView];
    
    self.cityTextField.inputView = self.cityChoosePan;
    self.cityTextField.inputAccessoryView = self.cityChooseToolView;
}

- (void)setupCityPickerView {
    
    self.cityChoosePan = [BQCityChoosePan cityPickerPan];
    self.cityChoosePan.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180);
}

- (void)setupCityPickerToolView {
    
    self.cityChooseToolView = [BQCityChooseToolView cityChooseToolView];
    self.cityChooseToolView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    WEAKSELF
    self.cityChooseToolView.cityChooseToolViewCancelBlock = ^(){
      
        [weakSelf.cityTextField resignFirstResponder];
    };
    self.cityChooseToolView.cityChooseToolViewCommitBlock = ^(){
        //先赋值
        weakSelf.cityTextField.text = weakSelf.cityChoosePan.selectedCity;
        [weakSelf.cityTextField resignFirstResponder];
    };
}


- (IBAction)clickManBtn:(UIButton *)manBtn {
    UIImage *imageNosel = [UIImage imageNamed:@"v2_noselected"];
    UIImage * imageSel = [UIImage imageNamed:@"v2_selected"];
    if ([self.manBtn.imageView.image isEqual:imageNosel]) {
        [self.manBtn setImage:imageSel forState:UIControlStateNormal];
        [self.womanBtn setImage:imageNosel forState:UIControlStateNormal];
    }else{

        [self.manBtn setImage:imageNosel forState:UIControlStateNormal];
    }
    
}


- (IBAction)clickWomanBtn:(id)womanBtn {
    UIImage *imageNosel = [UIImage imageNamed:@"v2_noselected"];
    UIImage * imageSel = [UIImage imageNamed:@"v2_selected"];
    if ([self.womanBtn.imageView.image isEqual:imageNosel]) {
        [self.womanBtn setImage:imageSel forState:UIControlStateNormal];
        [self.manBtn setImage:imageNosel forState:UIControlStateNormal];
    }else{
        [self.womanBtn setImage:imageNosel forState:UIControlStateNormal];
    }
}
- (IBAction)phoneNumDidChanged:(UITextField *)sender {
}



- (void)setInfoModel:(BQAddressModel *)infoModel {
    _infoModel = infoModel;
    self.contactsTextField.text = infoModel.accept_name;
    self.phoneNumTextField.text = infoModel.telphone;
    self.areaTextField.text = infoModel.addr_for_dealer;
    self.addressTextF.text = infoModel.address;
    self.cityTextField.text = infoModel.city_name;
    if ([infoModel.gender isEqualToString:@"1"]) {
        [self.manBtn setImage:[UIImage imageNamed:@"v2_selected"] forState:UIControlStateNormal];
    }else if([infoModel.gender isEqualToString:@"0"]){
        [self.womanBtn setImage:[UIImage imageNamed:@"v2_selected"] forState:UIControlStateNormal];
    }
}


@end
