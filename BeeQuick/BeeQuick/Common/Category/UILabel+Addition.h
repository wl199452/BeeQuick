//
//  UILabel+Addition.h
//
//

#import <UIKit/UIKit.h>

@interface UILabel (Addition)

+ (UILabel*) labelWithName:(NSString*)text font:(UIFont*)font;
+ (UILabel*) labelWithName:(NSString *)text font:(UIFont*)font textColor:(UIColor*)color;
+ (UILabel*) labelWithName:(NSString *)text font:(UIFont*)font hexColor:(uint32_t)hexColor;

@end
