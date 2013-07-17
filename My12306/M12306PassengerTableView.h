//
//  M12306PassengerTableView.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-14.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "M12306passengerTicketItem.h"
@interface M12306PassengerTableView : NSTableView<NSTableViewDataSource>

@property (weak,nonatomic) NSArray * data;

-(NSArray *)getSelectedCardNoArray;
-(void)initSelected:(NSArray *)array;
@end
