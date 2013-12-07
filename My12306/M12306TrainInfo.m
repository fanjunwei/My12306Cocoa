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
        self.data=data;
        queryLeftNewDTO=[data objectForKey:@"queryLeftNewDTO"];
        self.secretStr=[data objectForKey:@"secretStr"];
        self.train_no=[queryLeftNewDTO objectForKey:@"train_no"];
        self.station_train_code=[queryLeftNewDTO objectForKey:@"station_train_code"];
    }
    return self;
}

- (BOOL)Success:(NSString *)regstr
{
    NSRegularExpression *regx=[NSRegularExpression regularExpressionWithPattern:regstr options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSRange range= [regx rangeOfFirstMatchInString:self.station_train_code options:0 range:NSMakeRange(0, [self.station_train_code length])];
    if(range.location==0 && range.length==[self.station_train_code length])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(NSString *)TicketCountForSeat:(NSString *)seat
{
    NSArray * seatField=[NSArray arrayWithObjects:  @"ze_num",@"zy_num",@"swz_num",@"tz_num",@"gr_num",@"rw_num",@"yw_num",@"rz_num",@"yz_num",@"wz_num", nil];
    NSArray *seatValue = [NSArray arrayWithObjects: @"O",@"M",@"9",@"P",@"6",@"4",@"3",@"2",@"1",@"empty", nil];
    
    NSDictionary * map = [NSDictionary dictionaryWithObjects:seatField forKeys:seatValue];
    
    return [queryLeftNewDTO objectForKey:[map objectForKey:seat]];
    
}
@end
