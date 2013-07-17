//
//  M12306Form.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-12.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306Form.h"
@interface M12306Form()
@property(strong,nonatomic) NSString *actionURL;
@property (strong,nonatomic) NSMutableArray *queryStrings;
@property (strong,nonatomic) NSMutableArray *inputs;
- (id) init;
@end

@implementation M12306Form

- (id)init
{
    self=[super init];
    if(self!=nil)
    {
        self.queryStrings=[NSMutableArray arrayWithCapacity:0];
        self.inputs=[NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (id)initWithActionURL:(NSString *)url
{
    self=[self init];
    if(self!=nil)
    {
        self.actionURL =url;
    }
    return self;
}

- (void)setTagValue:(NSString *)value forKey:(NSString *)key
{
    for (int i=0; i<[self.inputs count]; i++) {
        M12306KeyValue * item = [self.inputs objectAtIndex:i];
        if([item.Key isEqualToString:key])
        {
            item.Value=value;
            return;
        }
    }
    [self.inputs addObject:[[M12306KeyValue alloc]initWithValue:value forKey:key]];
}
- (NSString *)getTagValue:(NSString *)key
{
    for (int i=0; i<[self.inputs count]; i++) {
        M12306KeyValue * item = [self.inputs objectAtIndex:i];
        if([item.Key isEqualToString:key])
        {
            return item.Value;
        }
    }
    return nil;
}

- (void)addTagValue:(NSString *)value forKey:(NSString *)key
{
    [self.inputs addObject:[[M12306KeyValue alloc]initWithValue:value forKey:key]];
}

-(void)addQueryStringValue:(NSString *)value forKey:(NSString *)key
{
    [self.queryStrings addObject:[[M12306KeyValue alloc]initWithValue:value forKey:key]];
}

-(NSString *)debug
{
    NSString * res=@"";
    for (int i=0; i<[self.inputs count]; i++) {
        M12306KeyValue * item = [self.inputs objectAtIndex:i];
            res=[res stringByAppendingFormat:@"%@:%@\n",item.key,item.Value];
    }
    return res;
}

- (NSString *)post
{
    NSString *strbody=@"";
    for (int i=0; i<[self.inputs count]; i++) {
        M12306KeyValue * item = [self.inputs objectAtIndex:i];
        if(i==0)
        {
            strbody=[strbody stringByAppendingFormat:@"%@",[item toString]];
        }
        else
        {
            strbody=[strbody stringByAppendingFormat:@"&%@",[item toString]];
        }
    }
    NSData *body = [strbody dataUsingEncoding:NSUTF8StringEncoding];
    NSURL * url;
    if([self.queryStrings count])
    {
        NSString * temurl = self.actionURL;
        NSRange range = [temurl rangeOfString:@"?"];
        if(range.location==NSNotFound)
        {
            temurl=[temurl stringByAppendingString:@"?"];
        }
        else
        {
            temurl=[temurl stringByAppendingString:@"&"];
        }
        for (int i=0; i<[self.queryStrings count]; i++) {
            M12306KeyValue * item = [self.queryStrings objectAtIndex:i];
            if(i==0)
            {
                temurl=[temurl stringByAppendingFormat:@"%@",[item toString]];
            }
            else
            {
                temurl=[temurl stringByAppendingFormat:@"&%@",[item toString]];
            }
        }
        url=[NSURL URLWithString:temurl];
        
    }
    else
    {
        url = [NSURL URLWithString:self.actionURL];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json, text/javascript, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:self.UserAgent forHTTPHeaderField:@"UserAgent"];
    if(self.referer!=nil)
    {
        [request setValue:self.referer forHTTPHeaderField:@"Referer"];
    }
    else
    {
        [request setValue:self.actionURL forHTTPHeaderField:@"Referer"];
    }
    NSData *data = [M12306URLConnection sendSynchronousRequest:request];
    
    return  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}
- (void)clearTag
{
    [self.inputs removeAllObjects];
}
@end
