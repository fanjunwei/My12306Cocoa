//
//  base64.h
//  My12306
//
//  Created by 范 俊伟 on 13-12-9.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"
@interface base64 : NSObject
+ (NSString*)encodeBase64String:(NSString*)input;
+ (NSString*)decodeBase64String:(NSString*)input;
+ (NSString*)encodeBase64Data:(NSData*)data;
+ (NSString*)decodeBase64Data:(NSData*)data;
@end
