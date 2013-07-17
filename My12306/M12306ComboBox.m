//
//  M12306ComboBox.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-13.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306ComboBox.h"
@interface M12306ComboBox()

@end
@implementation M12306ComboBox

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDataSource:self];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDataSource:self];
    }

    return self;
}

//- (void)drawRect:(NSRect)dirtyRect
//{
//    // Drawing code here.
//}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    return self.data.count;
}
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
    NSDictionary * item =[self.data objectAtIndex:index];
    NSString * display = [item objectForKey:@"display"];
    return display;
}

- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string
{
    for (int i=0; i<self.data.count; i++) {
        NSString * display=[[self.data objectAtIndex:i] objectForKey:@"display"];
        if ([display isEqualToString:string]) {
            NSLog(@"%@",string);
            return i;
        }

    }
    return NSNotFound;
}
- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)string
{
    for (int i=0; i<self.data.count; i++) {
   
        NSString * display = [[self.data objectAtIndex:i] objectForKey:@"display"];
        if ([display hasPrefix:string]) {
            if([display isEqualToString:string])
            {
                continue;
            }
            return display;
        }
        
    }
    return string;
}

- (NSString *)getSelectedDisplay
{
    return [[self.data objectAtIndex:[self indexOfSelectedItem]] objectForKey:@"display"];
}

- (NSString *)getSelectedValue
{
    return [[self.data objectAtIndex:[self indexOfSelectedItem]] objectForKey:@"value"];
    
}

@end
