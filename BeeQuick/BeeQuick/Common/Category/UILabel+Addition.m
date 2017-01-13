//
//  UILabel+Addition.m
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)


/**
 *  快速创建一个UILabel
 *
 *  @param text 文字
 *  @param font 文字大小
 *
 *  @return UILabel控件
 */
+ (UILabel *)labelWithName:(NSString*)text font:(UIFont*)font{
    
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = font;
    return label;
}


/**
 *  快速创建一个UILabel
 *
 *  @param text  文字
 *  @param font  字体大小
 *  @param color 文字颜色
 *
 *  @return UIlabel控件
 */
+ (UILabel *)labelWithName:(NSString *)text font:(UIFont*)font textColor:(UIColor*)color{
    
    UILabel *label = [UILabel labelWithName:text font:font];
    label.textColor = color;
    return label;
}


/**
 *  快速创建一个UIlabel
 *
 *  @param text     标签文字
 *  @param font     文字字体大小
 *  @param hexColor 文字颜色（16进制）
 *
 *  @return UILabel控件
 */
+ (UILabel *)labelWithName:(NSString *)text font:(UIFont*)font hexColor:(uint32_t)hexColor{
    
    UILabel *label = [UILabel labelWithName:text font:font];

    int r = ( hexColor & 0xFF0000 ) >> 16;
    int g = ( hexColor & 0x00FF00 ) >> 8;
    int b =   hexColor & 0x0000FF;
    
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    
    label.textColor = color;
    
    return label;
    
}

@end
