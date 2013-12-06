//
//  M12306passengerTicketItem.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-14.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306passengerTicketItem.h"

@implementation M12306passengerTicketItem
{
    NSDictionary *_CardTypeArray;
    NSDictionary *_TicketTypeArray;
}
- (NSDictionary *)CardTypeArray
{
    if(!_CardTypeArray)
    {
        _CardTypeArray=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"二代身份证",@"一代身份证",@"港澳通行证",@"台湾通行证",@"护照", nil] forKeys:[NSArray arrayWithObjects:@"1",@"2",@"C",@"G",@"B",nil]];
    }
    return _CardTypeArray;
}

- (NSDictionary *)TicketTypeArray
{
    if(!_TicketTypeArray)
    {
        _TicketTypeArray=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"成人票",@"儿童票",@"学生票",@"残军票", nil] forKeys:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",nil]];
    }
    return _TicketTypeArray;
}

- (void)addToForm:(M12306Form *)form forIndex:(NSInteger)index forSeat:(NSString *)seat
{
    if (self.Name != nil && ![self.Name isEqualToString:@""])
    {
        NSString *passengerTickets=[NSString stringWithFormat:@"%@,0,%@,%@,%@,%@,%@,N",seat,self.Ticket,self.Name,self.Cardtype,self.Cardno,self.Mobileno];
        [form addTagValue:passengerTickets forKey:@"passengerTickets"];
        [form addTagValue:@"" forKey:@"oldPassengers"];
        [form addTagValue:seat forKey:[NSString stringWithFormat:@"passenger_%ld_seat",index]];
//         [form addTagValue:@"1" forKey:[NSString stringWithFormat:@"passenger_%ld_seat_detail_select",index]];
        
        [form addTagValue:self.Ticket forKey:[NSString stringWithFormat:@"passenger_%ld_ticket",index]];
        [form addTagValue:self.Name forKey:[NSString stringWithFormat:@"passenger_%ld_name",index]];
        [form addTagValue:self.Cardtype forKey:[NSString stringWithFormat:@"passenger_%ld_cardtype",index]];
        [form addTagValue:self.Cardno forKey:[NSString stringWithFormat:@"passenger_%ld_cardno",index]];
        [form addTagValue:self.Mobileno forKey:[NSString stringWithFormat:@"passenger_%ld_mobileno",index]];
    }
    else
    {
        [form addTagValue:@"" forKey:@"oldPassengers"];
        [form addTagValue:@"" forKey:@"checkbox9"];
    }
}

- (NSString *)getInfo
{
    return [NSString stringWithFormat:@"***%@ %@ %@ %@ 电话:%@",self.Name,[self.TicketTypeArray objectForKey:self.Ticket],[self.CardTypeArray objectForKey:self.Cardtype],self.Cardno,self.Mobileno];
}
@end
