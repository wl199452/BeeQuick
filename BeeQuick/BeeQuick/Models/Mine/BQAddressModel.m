//
//  BQAddressModel.m
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQAddressModel.h"

@implementation BQAddressModel

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
}


#pragma mark -
#pragma mark - 解档
+ (NSArray<BQAddressModel *> *) unarchiver {
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"addressBook.plist"];
    
    NSArray* caseArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return caseArray;
}

#pragma mark -
#pragma mark - 归档
+ (void) archiver:(NSArray<BQAddressModel *> *) array{
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"addressBook.plist"];
    
    [NSKeyedArchiver archiveRootObject:array toFile:filePath];
}

// 解档
- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        
        u_int count;
        
        // 获取本类的所有成员变量
        Ivar* ivars = class_copyIvarList([self class], &count);
        for (u_int i=0; i<count; i++) {
            
            // 取出对应位置的成员变量
            Ivar ivar = ivars[i];
            
            const char* keyChar = ivar_getName(ivar);
            // 解档
            NSString* keyStr = [NSString stringWithUTF8String:keyChar];
            [self setValue:[decoder decodeObjectForKey:keyStr] forKey:keyStr];
        }
        free(ivars);
    }
    return self;
}

// 归档
- (void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int count = 0;
    // 获取本类的所有成员变量
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    // 遍历所有的成员变量
    for (int i = 0; i<count; i++) {
        // 取出对应位置的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *keyChar = ivar_getName(ivar);
        // 归档
        NSString *keyStr = [NSString stringWithUTF8String:keyChar];
        [encoder encodeObject:[self valueForKey:keyStr] forKey:keyStr];
    }
    // 释放
    free(ivars);
}


@end
