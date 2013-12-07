//
//  TrainInfo.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-11.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306TrainInfo.h"

@implementation M12306TrainInfo
{
    NSDictionary * queryLeftNewDTO;
    NSDictionary * ticketCouts;
    NSDictionary * mData;
}

-(id) init
{
    self = [super init];
    
    return self;
}

-(id) initWithDictionary:(NSDictionary *)data
{
    self = [self init];
    if(self)
    {
        mData=data;
        queryLeftNewDTO=[data objectForKey:@"queryLeftNewDTO"];
        self.secretStr=[data objectForKey:@"secretStr"];
        self.TrainNo=[queryLeftNewDTO objectForKey:@"train_no"];
        self.TrainName=[queryLeftNewDTO objectForKey:@"station_train_code"];
        
        ticketCouts=[M12306TrainInfo getCount:[queryLeftNewDTO objectForKey:@"yp_info"]];
    }
    return self;
}

- (BOOL)Success:(NSString *)regstr
{
    NSRegularExpression *regx=[NSRegularExpression regularExpressionWithPattern:regstr options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSRange range= [regx rangeOfFirstMatchInString:self.TrainName options:0 range:NSMakeRange(0, [self.TrainName length])];
    if(range.location==0 && range.length==[self.TrainName length])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//-(NSString *)TicketCountForSeat:(NSString *)seat
//{
//    NSArray * seatField=[NSArray arrayWithObjects:  @"ze_num",@"zy_num",@"swz_num",@"tz_num",@"gr_num",@"rw_num",@"yw_num",@"rz_num",@"yz_num",@"wz_num", nil];
//    NSArray *seatValue = [NSArray arrayWithObjects: @"O",@"M",@"9",@"P",@"6",@"4",@"3",@"2",@"1",@"empty", nil];
//    
//    NSDictionary * map = [NSDictionary dictionaryWithObjects:seatField forKeys:seatValue];
//    
//    return [queryLeftNewDTO objectForKey:[map objectForKey:seat]];
//    
//}



+ (NSDictionary *)getCount:(NSString *) ypInfoDetail
{
    NSMutableDictionary *table=[NSMutableDictionary dictionary];
    NSRegularExpression *reZuo=[NSRegularExpression regularExpressionWithPattern:@"(.)\\*\\*\\*\\*\\*0(\\d\\d\\d)" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    [reZuo enumerateMatchesInString:ypInfoDetail options:0 range:NSMakeRange(0, [ypInfoDetail length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if ([result numberOfRanges]>0) {
            NSString *seat=[ypInfoDetail substringWithRange:[result rangeAtIndex:1]];
            NSString *count = [ypInfoDetail substringWithRange:[result rangeAtIndex:2]];
            [table setValue:count forKey:seat];
        }
    }];
    
    NSRegularExpression *reWu=[NSRegularExpression regularExpressionWithPattern:@"(.)\\*\\*\\*\\*\\*3(\\d\\d\\d)" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    [reWu enumerateMatchesInString:ypInfoDetail options:0 range:NSMakeRange(0, [ypInfoDetail length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if ([result numberOfRanges]>0) {
            
            NSString *count = [ypInfoDetail substringWithRange:[result rangeAtIndex:2]];
            [table setValue:count forKey:@"无座"];
        }
    }];
    //MatchCollection mZuos = reZuo.Matches(ypInfoDetail);
    return [table copy];
    
}

- (NSInteger)TicketCountForSeat:(NSString *)seat
{
    NSString * strcount= [ticketCouts objectForKey:seat];
    if(strcount!=nil)
    {
        return  [strcount intValue];
    }
    else
    {
        return 0;
    }
}
@end
