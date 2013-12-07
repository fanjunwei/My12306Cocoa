//
//  TrainInfo.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-11.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M12306TrainInfo : NSObject

@property (strong,nonatomic) NSString *train_no;
@property (strong,nonatomic) NSString *station_train_code ;
@property (strong,nonatomic) NSDictionary *data;
@property (strong,nonatomic) NSString *secretStr;

-(id) init;

-(id) initWithYuanshi:(NSDictionary *) yuanshi;

- (BOOL) Success:(NSString *)regstr;

- (NSInteger) TicketCountForSeat:(NSString *)seat;
@end
