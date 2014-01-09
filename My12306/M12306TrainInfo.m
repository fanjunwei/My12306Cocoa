//
//  TrainInfo.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-11.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306TrainInfo.h"
#import "base64.h"
@implementation M12306TrainInfo
@synthesize ypinfo;
-(id) init
{
    self = [super init];
    
    return self;
}

-(id) initWithDictionary:(NSDictionary *)data
{
    NSString* secretStr=[[data objectForKey:@"secretStr"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self initWithSecretStr:secretStr];
}

-(id) initWithSecretStr:(NSString *)secretStr
{
    self = [self init];
    if(self)
    {
        @try {
            self.secretStr=secretStr;
            NSString *secretStrdec= [base64 decodeBase64String: secretStr];
            NSArray *args=[secretStrdec componentsSeparatedByString:@"#"];
            self.TrainName=[args objectAtIndex:2];
            self.TrainNo=[args objectAtIndex:5];
            self.FromStationCode=[args objectAtIndex:6];
            self.TotationCode=[args objectAtIndex:7];
            ypinfo=[args objectAtIndex:13];
        }
        @catch (NSException *exception) {
            return nil;
        }
        
        
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

- (int)TicketCountForSeat:(NSString *)seat
{
    //NSString *ypinfo=[queryLeftNewDTO objectForKey:@"yp_info"];
    BOOL find=NO;
    int seat_1 = 0;
    int seat_2 = 0;
    for (int i=0; i<ypinfo.length; i+=10) {
        NSString *s = [ypinfo substringWithRange:NSMakeRange(i, 10)];
        NSString *c_seat=[s substringWithRange:NSMakeRange(0, 1)];
        if ([c_seat isEqualToString: seat]) {
            NSString * count =[s substringWithRange:NSMakeRange(6, 4)];
            int intcount = count.intValue;
            find=YES;
            if (intcount < 3000) {
                seat_1 = intcount;
            }
            else {
                seat_2 = (intcount - 3000);
            }
        }
    }
    
    if(find)
        return seat_1+seat_2;
    else
        return -1;
}
@end
