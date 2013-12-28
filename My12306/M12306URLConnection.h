//
//  M12306URLConnection.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-11.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#define UserAgent @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1"
@interface M12306URLConnection : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSURLDownloadDelegate>

@property NSURLConnection* connection;
@property NSMutableData * data;
@property BOOL finish;

+ (NSData *)sendSynchronousRequest:(NSMutableURLRequest*) request;

+(void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;
@end
