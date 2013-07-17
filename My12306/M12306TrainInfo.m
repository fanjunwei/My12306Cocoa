//
//  TrainInfo.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-11.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306TrainInfo.h"

@implementation M12306TrainInfo


-(id) init
{
    self = [super init];
    self.ticketCouts=[NSMutableDictionary dictionary];
    self.info=[NSMutableDictionary dictionary];
    return self;
}

-(id) initWithYuanshi:(NSString *)yuanshi
{
    self = [self init];
    if(self)

    {self.Yuanshi=yuanshi;
    NSArray* commsp = [yuanshi componentsSeparatedByString:@"#"];
    NSArray* setField=[NSArray arrayWithObjects:@"station_train_code", @"lishi", @"train_start_time", @"trainno4", @"from_station_telecode", @"to_station_telecode", @"arrive_time", @"from_station_name", @"to_station_name", @"from_station_no", @"to_station_no", @"ypInfoDetail", @"mmStr", @"locationCode", nil];
    for (int i=0; i<[setField count]; i++) {
        [self.info setValue:[commsp objectAtIndex:i] forKey:[setField objectAtIndex:i]];
    }
        self.TrainCode=[self.info objectForKey:@"trainno4"];
        self.TrainName=[self.info objectForKey:@"station_train_code"];
        self.StartTime=[self.info objectForKey:@"train_start_time"];
        self.ArriveTime=[self.info objectForKey:@"arrive_time"];
        self.FromStationName=[self.info objectForKey:@"from_station_name"];
        self.FromStationCode=[self.info objectForKey:@"from_station_telecode"];
        self.ToStationName=[self.info objectForKey:@"to_station_name"];
        self.TotationCode=[self.info objectForKey:@"to_station_telecode"];
        self.ticketCouts=[M12306TrainInfo getCount: [self.info objectForKey:@"ypInfoDetail"]];
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
    NSString * strcount= [self.ticketCouts objectForKey:seat];
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
