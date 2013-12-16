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
@synthesize mData;
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
        self.secretStr=[[data objectForKey:@"secretStr"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.TrainNo=[queryLeftNewDTO objectForKey:@"train_no"];
        self.TrainName=[queryLeftNewDTO objectForKey:@"station_train_code"];
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

- (NSString *)TicketCountForSeat:(NSString *)seat
{
    NSString *ypinfo=[queryLeftNewDTO objectForKey:@"yp_info"];
    NSString * rt = @"";
    int seat_1 = -1;
    int seat_2 = -1;
    for (int i=0; i<ypinfo.length; i+=10) {
        NSString *s = [ypinfo substringWithRange:NSMakeRange(i, 10)];
        NSString *c_seat=[s substringWithRange:NSMakeRange(0, 1)];
        if ([c_seat isEqualToString: seat]) {
            NSString * count =[s substringWithRange:NSMakeRange(6, 4)];
            int intcount = count.intValue;
            if (intcount < 3000) {
                seat_1 = intcount;
            } else {
                seat_2 = (intcount - 3000);
            }
        }
    }
    if (seat_1 > -1) {
        rt = [rt stringByAppendingFormat:@"%d",seat_1];
    }
    if (seat_2 > -1) {
        rt = [rt stringByAppendingFormat:@",无座%d",seat_2];
    }
    return rt;
}
@end
