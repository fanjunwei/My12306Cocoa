//
//  TrainInfo.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-11.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M12306TrainInfo : NSObject

@property (strong,nonatomic) NSString *TrainNo;
@property (strong,nonatomic) NSString *TrainName ;
@property (strong,nonatomic) NSString *StartTime;
@property (strong,nonatomic) NSString *ArriveTime ;
//@property (strong,nonatomic) NSString *FromStationName;
@property (strong,nonatomic) NSString *FromStationCode;
//@property (strong,nonatomic) NSString *ToStationName;
@property (strong,nonatomic) NSString *TotationCode;
@property (strong,nonatomic) NSMutableDictionary *info;

@property (strong,nonatomic) NSString *secretStr;

@property (strong,nonatomic)NSString *ypinfo;
-(id) init;

-(id) initWithDictionary:(NSDictionary *) yuanshi;
-(id) initWithSecretStr:(NSString *)secretStr;
- (BOOL) Success:(NSString *)regstr;

- (int) TicketCountForSeat:(NSString *)seat;
@end
