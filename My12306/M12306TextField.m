//
//  M12306TextField.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-12.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306TextField.h"
@interface M12306TextField ()
@property SEL txtChange;
@property (weak,nonatomic)id txtChangeToTarget;
@end
@implementation M12306TextField

//- (id)initWithFrame:(NSRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code here.
//    }
//    
//    return self;
//}

- (void)textDidChange:(NSNotification *)notification
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if(self.txtChangeToTarget!=nil && self.txtChange!=nil)
    {
        [self.txtChangeToTarget performSelector:self.txtChange];
    }
#pragma clang diagnostic pop
}

- (void)setTextChangeAction:(SEL)action toTarget:(id)target
{
    self.txtChange=action;
    self.txtChangeToTarget=target;
}
@end
