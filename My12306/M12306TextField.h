//
//  M12306TextField.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-12.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface M12306TextField : NSTextField

- (void) setTextChangeAction:(SEL) action toTarget:(id) target;
@end
