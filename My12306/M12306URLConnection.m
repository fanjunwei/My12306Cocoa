//
//  M12306URLConnection.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-11.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306URLConnection.h"

static NSTimeInterval sTimeoutInterval = 60;
@implementation M12306URLConnection


+(void)setTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    sTimeoutInterval=timeoutInterval;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    [self.data setLength:0];
    NSHTTPURLResponse * http =(NSHTTPURLResponse *) response;
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[http allHeaderFields] forURL:[http URL]];
    for(int i=0;i<[cookies count];i++)
    {
        //[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[cookies objectAtIndex:i]];
        if(self.cookieStore)
        {
            [self.cookieStore addCookie:[cookies objectAtIndex:i]];
        }
        
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.finish=YES;
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.finish=YES;
}
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection{
    return NO;
}
//下面两段是重点，要服务器端单项HTTPS 验证，iOS 客户端忽略证书验证。
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    //NSLog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}

//处理数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

+ (NSData *)sendSynchronousRequest:(NSMutableURLRequest *)request forCookieStore:(M12306CookieStore *)cookieStore
{
    M12306URLConnection *res = [[M12306URLConnection alloc]init];
    res.cookieStore=cookieStore;
    res.data=[NSMutableData dataWithCapacity:128];
    res.finish =NO;
    [request setTimeoutInterval:sTimeoutInterval];
    [request setValue:UserAgent forHTTPHeaderField:@"User-Agent"];
    if(cookieStore)
    {
        [request setAllHTTPHeaderFields:[cookieStore requestHeaderFields]];
    }
    //HTTP_X_FORWARDED_FOR
    //MT-Proxy-ID=1804289383
    //[request setValue:@"1804281312312" forHTTPHeaderField:@"MT-Proxy-ID"];
    //[request setValue:@"342.108.232.188" forHTTPHeaderField:@"X-Forwarded-For"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
    res.connection=[[NSURLConnection alloc]initWithRequest:request delegate:res];
    while (!res.finish) {
        
       [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return res.data;
}
@end
