//
//  BQTicketModel.m
//  BeeQuick
//
//  Created by 郭选 on 2016/12/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQTicketModel.h"

@implementation BQTicketModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        NSMutableDictionary *dictM = [NSMutableDictionary new];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            [dictM setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
            
        }];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqual:@"description"]) {
        self.desc = value;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
