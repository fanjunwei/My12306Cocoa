//
//  M12306QueryTableView.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-15.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306QueryTableView.h"

@implementation M12306QueryTableView

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
        NSArray *cname =[NSArray arrayWithObjects:@"序号",@"车次",@"发站",@"到站",@"历时",@"商务座",@"特等座",@"一等座",@"二等座",@"高级软卧",@"软卧",@"硬卧",@"软座",@"硬座",@"无座",@"其他",@"购票", nil];
        for (int i=0; i<[cname count]; i++) {
            NSTableColumn * column = [[NSTableColumn alloc]initWithIdentifier:[cname objectAtIndex:i]];
            [column.headerCell setTitle:[cname objectAtIndex:i]];
            [column setWidth:50];
            [column.dataCell setEditable:NO];
            [column.dataCell setSelectable:YES];
            [self addTableColumn:column];
            
        }
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
    NSDictionary *item=[self.data objectAtIndex:row];
    NSString *cname=tableColumn.identifier;
//    NSTextFieldCell * cell=[tableColumn dataCellForRow:row];
//    cell.stringValue=[item objectForKey:cname];
    //[cell setAllowsEditingTextAttributes:NO];
    return [item objectForKey:cname];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{

}
@end
