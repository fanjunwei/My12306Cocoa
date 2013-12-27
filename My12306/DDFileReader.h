//
//  DDFileReader.h
//  My12306
//
//  Created by 范 俊伟 on 13-12-27.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDFileReader : NSObject
@property (nonatomic, strong) NSString * lineDelimiter;
@property (nonatomic) NSUInteger chunkSize;

- (id) initWithFileHandle:(NSFileHandle *)aHandle;

- (NSString *) readLine;
- (NSString *) readTrimmedLine;

@end
