//
//  ArrowView.m
//  GPS Exif Demo
//
//  Created by Baris Atamer on 15/04/16.
//  Copyright © 2016 Baris Atamer. All rights reserved.
//

#import "ArrowView.h"

@implementation ArrowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
#if TARGET_OS_IPHONE
    CGContextRef ctx = UIGraphicsGetCurrentContext();	// iOS
#else
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];	// OS X
#endif
    
    // Enable the following lines for flipped coordinate systems
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    
    // Arrow Shape
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, 106.166, 198.414);
    CGPathAddLineToPoint(pathRef, NULL, 212.332, 92.248);
    CGPathAddLineToPoint(pathRef, NULL, 146.524, 92.248);
    CGPathAddLineToPoint(pathRef, NULL, 146.524, 0);
    CGPathAddLineToPoint(pathRef, NULL, 65.807, 0);
    CGPathAddLineToPoint(pathRef, NULL, 65.807, 92.248);
    CGPathAddLineToPoint(pathRef, NULL, 0, 92.248);
    CGPathAddLineToPoint(pathRef, NULL, 106.166, 198.414);
    
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5f);
    CGContextAddPath(ctx, pathRef);
    CGContextFillPath(ctx);
    
    CGPathRelease(pathRef);


}

@end
