//
//  M12306ComboBox.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-13.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface M12306ComboBox : NSComboBox<NSComboBoxDataSource>
@property (strong,nonatomic) NSArray * data;

- (NSString *)getSelectedValue;
- (NSString *)getSelectedDisplay;
@end
