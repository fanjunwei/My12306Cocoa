//
//  M12306GifView.m
//  My12306
//
//  Created by 范 俊伟 on 14-1-1.
//  Copyright (c) 2014年 fjw. All rights reserved.
//

#import "M12306GifView.h"
@interface M12306GifView()
@property (strong,nonatomic) NSArray * images;
@property (nonatomic)BOOL isShow;
@end
@implementation M12306GifView
{
    NSInteger index;
}
//- (id)initWithFrame:(NSRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code here.
//    }
//    return self;
//}

-(void)redraw
{
    index++;
    if (index>=self.images.count) {
        index=0;
    }
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.isShow) {
        NSImage *image = [self.images objectAtIndex:index];
        [image drawInRect:dirtyRect];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(redraw) object:nil];
        [self performSelector:@selector(redraw) withObject:nil afterDelay:0.8];
    }
    
//	[super drawRect:dirtyRect];
//	
//    // Drawing code here.
}

- (NSImage*) imageFromCGImageRef:(CGImageRef)image

{
    
    NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
    
    CGContextRef imageContext = nil;
    
    NSImage* newImage = nil;
    
    
    
    // Get the image dimensions.
    
    imageRect.size.height = CGImageGetHeight(image);
    
    imageRect.size.width = CGImageGetWidth(image);
    
    
    
    // Create a new image to receive the Quartz image data.
    
    newImage = [[NSImage alloc] initWithSize:imageRect.size];
    
    [newImage lockFocus];
    
    
    
    // Get the Quartz context and draw.
    
    imageContext = (CGContextRef)[[NSGraphicsContext currentContext]
                                  
                                  graphicsPort];
    
    CGContextDrawImage(imageContext, *(CGRect*)&imageRect, image);
    
    [newImage unlockFocus];
    
    
    
    return newImage;
    
}

-(void)setImageData:(NSData *)imageData
{
    _imageData=imageData;
    [self decodeWithData:_imageData];
}

-(void)decodeWithData:(NSData *)data
{
    self.isShow=NO;
    index=0;
    NSMutableArray * array=[NSMutableArray array];
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef) data, NULL);
    if (src)
    {
        //获取gif的帧数
        NSUInteger frameCount = CGImageSourceGetCount(src);
        //获取GfiImage的基本数据
        NSDictionary *gifProperties = (__bridge NSDictionary *) CGImageSourceCopyProperties(src, NULL);
        if(gifProperties)
        {
            //由GfiImage的基本数据获取gif数据
//            NSDictionary *gifDictionary =[gifProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary];
            //获取gif的播放次数
//            NSUInteger loopCount = [[gifDictionary objectForKey:(NSString*)kCGImagePropertyGIFLoopCount] integerValue];
            for (NSUInteger i = 0; i < frameCount; i++)
            {
                //得到每一帧的CGImage
                CGImageRef img = CGImageSourceCreateImageAtIndex(src, (size_t) i, NULL);
                if (img)
                {
                    NSImage *nsimage = [self imageFromCGImageRef:img];
                    [array addObject:nsimage];
                    //把CGImage转化为UIImage
                    //CIImage *frameImage = [CIImage imageWithCGImage:img];
                    
                    //获取每一帧的图片信息
//                    NSDictionary *frameProperties = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(src, (size_t) i, NULL);
//                    if (frameProperties)
//                    {
//                        //由每一帧的图片信息获取gif信息
//                        NSDictionary *frameDictionary = [frameProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary];
//                        //取出每一帧的delaytime
//                        CGFloat delayTime = [[frameDictionary objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] floatValue];
//                        
//                        //TODO 这里可以实现边解码边回调播放或者把每一帧image和delayTime存储起来
//                        CFRelease((__bridge CFTypeRef)(frameProperties));
//                    }
                    CGImageRelease(img);
                }
            }
            CFRelease((__bridge CFTypeRef)(gifProperties));
        }
        CFRelease(src);
    }
    self.images=array.copy;
    self.isShow=YES;
    [self setNeedsDisplay:YES];
}

@end
