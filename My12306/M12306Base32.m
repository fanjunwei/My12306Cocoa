//
//  M12306Base32.m
//  My12306
//
//  Created by 范 俊伟 on 13-9-12.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306Base32.h"

@implementation M12306Base32
{
    int delta;
}

-(id)init
{
    if(self=[super init])
    {
        delta=0x9E3779B8;
        
    }
    return self;
}

//-(NSData *)stringToLongArray:(NSString *)str forLen:(BOOL)hasLen
//{
//    NSMutableData * data=[NSMutableData data];
//    
//    
//}
//
//-(NSString *)encrypt:(NSString *)string forKey:(NSString *)key {
// 
//    int *v = (int *)string.UTF8String;
//  
//    int *k = (int *)key.UTF8String;
//    
//    if (k.length < 4) {
//        k.length = 4;
//    }
//    var n = v.length - 1;
//    var z = v[n], y = v[0];
//    var mx, e, p, q = Math.floor(6 + 52 / (n + 1)), sum = 0;
//    while (0 < q--) {
//        sum = sum + delta & 0xffffffff;
//        e = sum >>> 2 & 3;
//        for (p = 0; p < n; p++) {
//            y = v[p + 1];
//            mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y)
//            + (k[p & 3 ^ e] ^ z);
//            z = v[p] = v[p] + mx & 0xffffffff;
//        }
//        y = v[0];
//        mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y)
//        + (k[p & 3 ^ e] ^ z);
//        z = v[n] = v[n] + mx & 0xffffffff;
//    }
//    return longArrayToString(v, false);
//};

@end
