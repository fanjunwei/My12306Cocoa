//
//  M12306passengerTicketItem.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-14.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M12306Form.h"
@interface M12306passengerTicketItem : NSObject
@property (strong,nonatomic)NSString *Cardno;
@property (strong,nonatomic)NSString *Cardtype;
@property (strong,nonatomic)NSString *Mobileno;
@property (strong,nonatomic)NSString *Name;
@property (strong,nonatomic)NSString *Ticket;
@property NSInteger state;
@property (strong,nonatomic,readonly)NSDictionary * CardTypeArray;
@property (strong,nonatomic,readonly)NSDictionary * TicketTypeArray;
-(void)addToForm:(M12306Form *)form forIndex:(NSInteger)index forSeat:(NSString *)seat;
-(NSString *)getInfo;
@end
