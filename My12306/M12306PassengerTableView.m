//
//  M12306PassengerTableView.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-14.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306PassengerTableView.h"
@interface M12306PassengerTableView()

@end
@implementation M12306PassengerTableView

//- (id)initWithFrame:(NSRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code here.
//    }
//    
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDataSource:self];
    }
    
    return self;
}




- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if(self.data)
    {
        return [self.data count];
    }
    else
    {
        return 0;
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    M12306passengerTicketItem *item=[self.data objectAtIndex:row];
    if([tableColumn.identifier isEqualToString:@"name"])
    {
        NSButtonCell * cell= [tableColumn dataCellForRow:row];
        [cell setTitle:item.Name];
        [cell setState:item.state];
        return cell;
    }
    else if([tableColumn.identifier isEqualToString:@"cardno"])
    {
        return item.Cardno;
    }
    return nil;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    M12306passengerTicketItem *item=[self.data objectAtIndex:row];
    if([tableColumn.identifier isEqualToString:@"name"])
    {
        item.state=[object intValue];
    }
}
-(NSArray *)getSelectedCardNoArray
{
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<[self.data count]; i++) {
        M12306passengerTicketItem * item =[self.data objectAtIndex:i];
        if(item.state)
        {
            [array addObject:item.Cardno];
        }
    }
    return (NSArray *)array;
}
-(void)initSelected:(NSArray *)array
{
    if(array!=nil)
    {
        for (int i=0; i<[self.data count]; i++) {
            M12306passengerTicketItem * item =[self.data objectAtIndex:i];
            NSString *cardNo=item.Cardno;
            
            if([array indexOfObject:cardNo]!=NSNotFound)
            {
                item.state=1;
            }
            else
            {
                item.state=0;
            }
        }
    }
}
@end
