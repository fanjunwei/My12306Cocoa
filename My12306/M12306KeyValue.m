//
//  M12306KeyValue.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-12.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306KeyValue.h"
#import "M12306Utility.h"
@implementation M12306KeyValue

- (id)initWithValue:(NSString *)value forKey:(NSString *)key
{
    self = [self init];
    if(self!=nil)
    {
        self.Key = key;
        self.Value = value;
    }
    return self;
}
- (NSString *)toString
{
    NSString * urlKey = [M12306Utility encodeToPercentEscapeString:self.Key];
    NSString * urlValue = [M12306Utility encodeToPercentEscapeString:self.Value];
    return [NSString stringWithFormat:@"%@=%@",urlKey,urlValue];
}

- (NSString *)description
{
    return self.Value;
}

@end
