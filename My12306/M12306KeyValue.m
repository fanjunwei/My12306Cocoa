//
//  M12306KeyValue.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-12.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306KeyValue.h"

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
    return [NSString stringWithFormat:@"%@=%@",self.Key,self.Value];
}

- (NSString *)description
{
    return self.Value;
}

@end
