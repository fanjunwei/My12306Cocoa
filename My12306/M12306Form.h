//
//  M12306Form.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-12.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M12306KeyValue.h"
#import "M12306URLConnection.h"

@interface M12306Form : NSObject

@property (strong,nonatomic) NSString* referer;



- (id)initWithActionURL:(NSString *)url;

- (void)setTagValue:(NSString *)value forKey:(NSString *)key;
- (NSString *)getTagValue:(NSString *)key;
- (void)addTagValue:(NSString *)value forKey:(NSString *)key;
- (void)clearTag;
- (NSString *)post;
- (NSString *)debug;
- (void)addQueryStringValue:(NSString *)value forKey:(NSString *)key;
@end
