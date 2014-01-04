//
//  M12306CookieStore.h
//  My12306
//
//  Created by 范 俊伟 on 14-1-4.
//  Copyright (c) 2014年 fjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M12306CookieStore : NSObject
-(void)addCookie:(NSHTTPCookie *)cookie;
-(void)clearCookie;
-(NSDictionary *)requestHeaderFields;
@end
