//
//  M12306KeyValue.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-12.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M12306KeyValue : NSObject
@property (strong,nonatomic) NSString *Key;
@property (strong,nonatomic) NSString *Value;

- (id)initWithValue:(NSString *) value forKey:(NSString *) key;
- (NSString *)toString;
@end
