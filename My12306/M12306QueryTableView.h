//
//  M12306QueryTableView.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-15.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface M12306QueryTableView : NSTableView<NSTableViewDataSource>

@property (weak,nonatomic) NSArray * data;
@property (nonatomic,strong)NSString *trainName;
@end
