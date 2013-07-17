//
//  M12306URLConnection.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-11.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M12306URLConnection : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSURLDownloadDelegate>

@property NSURLConnection* connection;
@property NSMutableData * data;
@property BOOL finish;

+ (NSData *)sendSynchronousRequest:(NSURLRequest*) request;
@end
