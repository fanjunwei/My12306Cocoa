//
//  M12306CookieStore.m
//  My12306
//
//  Created by 范 俊伟 on 14-1-4.
//  Copyright (c) 2014年 fjw. All rights reserved.
//

#import "M12306CookieStore.h"
@interface M12306CookieStore()
@property (nonatomic,strong)NSMutableArray *cookies;
@end
@implementation M12306CookieStore

-(id)init
{
    self=[super init];
    if(self)
    {
        self.cookies=[NSMutableArray array];
    }
    return self;
}

-(void)addCookie:(NSHTTPCookie *)cookie
{
    [self.cookies addObject:cookie];
}

-(void)clearCookie
{
    [self.cookies removeAllObjects];
}

-(NSDictionary *)requestHeaderFields
{
    NSDictionary * res=[NSHTTPCookie requestHeaderFieldsWithCookies:self.cookies];
    return res;
}

@end
