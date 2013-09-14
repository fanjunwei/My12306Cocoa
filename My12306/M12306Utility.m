//
//  M12306Utility.m
//  My12306
//
//  Created by 范 俊伟 on 13-9-13.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306Utility.h"

@implementation M12306Utility
+(NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    if(input)
    {
        CFStringRef inputref = CFBridgingRetain(input);
        NSString *outputStr = (NSString *)CFBridgingRelease(
                                                            (CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                     inputref,
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                     kCFStringEncodingUTF8)));
        CFRelease(inputref);
        return outputStr;
    }
    else
    {
        return nil;
    }
}
@end
