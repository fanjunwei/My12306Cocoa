//
//  DDFileReader.m
//  My12306
//
//  Created by 范 俊伟 on 13-12-27.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "DDFileReader.h"



@interface NSData (DDAdditions)

- (NSRange) rangeOfData_dd:(NSData *)dataToFind;

@end

@implementation NSData (DDAdditions)

- (NSRange) rangeOfData_dd:(NSData *)dataToFind {
    
    const void * bytes = [self bytes];
    NSUInteger length = [self length];
    
    const void * searchBytes = [dataToFind bytes];
    NSUInteger searchLength = [dataToFind length];
    NSUInteger searchIndex = 0;
    
    NSRange foundRange = {NSNotFound, searchLength};
    for (NSUInteger index = 0; index < length; index++) {
        if (((char *)bytes)[index] == ((char *)searchBytes)[searchIndex]) {
            //the current character matches
            if (foundRange.location == NSNotFound) {
                foundRange.location = index;
            }
            searchIndex++;
            if (searchIndex >= searchLength) { return foundRange; }
        } else {
            searchIndex = 0;
            foundRange.location = NSNotFound;
        }
    }
    return foundRange;
}

@end

@implementation DDFileReader
{
    NSFileHandle * fileHandle;
    NSData* lastData;
    //unsigned long long currentOffset;
}
@synthesize lineDelimiter, chunkSize;

- (id) initWithFileHandle:(NSFileHandle *)aHandle {
    if (self = [super init]) {
        fileHandle = aHandle;
        if (fileHandle == nil) {
             return nil;
        }
        
        lineDelimiter = @"\n";
        chunkSize = 10;
    }
    return self;
}

- (void) dealloc {
    [fileHandle closeFile];
}

- (NSString *) readLine {
   // if (currentOffset >= totalFileLength) { return nil; }
    
    NSData * newLineData = [lineDelimiter dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData * currentData = [[NSMutableData alloc] init];
    if(lastData)
        [currentData appendData:lastData];
    BOOL shouldReadMore = YES;
    
 
    while (shouldReadMore) {
        //if (currentOffset >= totalFileLength) { break; }
        NSData * chunk = [fileHandle readDataOfLength:chunkSize];
        if(!chunk || chunk.length<=0)
        {
            return nil;
        }
        NSRange newLineRange = [chunk rangeOfData_dd:newLineData];
        if (newLineRange.location != NSNotFound) {
            
            //include the length so we can include the delimiter in the string
            if(newLineRange.location+newLineData.length<chunk.length)
            {
                lastData=[chunk subdataWithRange:NSMakeRange(newLineRange.location+newLineData.length, chunk.length-(newLineRange.location+newLineData.length))];
            }
            chunk = [chunk subdataWithRange:NSMakeRange(0, newLineRange.location+[newLineData length])];
            shouldReadMore = NO;
        }
        [currentData appendData:chunk];
        //currentOffset += [chunk length];
    }

    
    NSString * line = [[NSString alloc] initWithData:currentData encoding:NSUTF8StringEncoding];
       return line;
}

- (NSString *) readTrimmedLine {
    return [[self readLine] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end