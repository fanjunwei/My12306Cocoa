//
//  M12306URLConnection.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-11.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M12306CookieStore.h"
#define UserAgent @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.73.11 (KHTML, like Gecko) Version/7.0.1 Safari/537.73.11"
@interface M12306URLConnection : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSURLDownloadDelegate>

@property NSURLConnection* connection;
@property NSMutableData * data;
@property BOOL finish;
@property M12306CookieStore * cookieStore;

+ (NSData *)sendSynchronousRequest:(NSMutableURLRequest *)request forCookieStore:(M12306CookieStore *)cookieStore;

+(void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;
@end
