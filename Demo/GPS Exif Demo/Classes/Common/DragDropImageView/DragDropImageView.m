//
//  DragDropImageView.m
//  BA_Icon_Generator
//
//  Created by Baris Atamer on 4/11/16.
//  Copyright © 2016 barisatamer. All rights reserved.
//

#import "DragDropImageView.h"
#import "ArrowView.h"

@implementation DragDropImageView
{
    ArrowView *_arrowView;
}
NSString *kPrivateDragUTI = @"com.dragdropimageview";

- (id) initWithCoder:(NSCoder *)coder {

    self = [super initWithCoder:coder];
        
    if (self) {
        
        [self registerForDraggedTypes:[NSImage imageTypes]];
        
        _arrowView = [[ArrowView alloc] initWithFrame:[self initArrowFrame]];
        [self addSubview:_arrowView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(frameDidChange)
                                                     name:NSViewFrameDidChangeNotification
                                                   object:self];
        
        [self setImageScaling:NSImageScaleProportionallyDown];
    }
    
    return self;
}

- (void)frameDidChange {
    [_arrowView setFrame:[self initArrowFrame]];
}

- (NSRect) initArrowFrame {
    return NSMakeRect(self.frame.size.width*.5 - 100,
                                    self.frame.size.height*.5 -100 , 212, 200);
}

- (NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender {

    if ([NSImage canInitWithPasteboard:[sender draggingPasteboard]] && [sender draggingSourceOperationMask] & NSDragOperationCopy) {
        highlight = YES;
        
        [self setNeedsDisplay: YES];
        [sender enumerateDraggingItemsWithOptions:NSDraggingItemEnumerationConcurrent forView:self classes:[NSArray arrayWithObject:[NSPasteboardItem class]] searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger idx, BOOL *stop) {
            
            if (![[[draggingItem item] types] containsObject:kPrivateDragUTI]) {
                *stop = YES;
            } else {
                
                [draggingItem setDraggingFrame:self.bounds contents:[[[draggingItem imageComponents] objectAtIndex:0] contents]];
            }
            
        }];
        return NSDragOperationCopy;
        
    }

    return NSDragOperationNone;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    
    highlight = NO;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    CGFloat padding = 2;
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef,    NULL, dirtyRect.origin.x + padding , dirtyRect.origin.y + padding );
    CGPathAddLineToPoint(pathRef, NULL, dirtyRect.size.width - padding, dirtyRect.origin.y + padding);
    CGPathAddLineToPoint(pathRef, NULL, dirtyRect.size.width - padding, dirtyRect.size.height - padding);
    CGPathAddLineToPoint(pathRef, NULL, dirtyRect.origin.x + padding, dirtyRect.size.height - padding);
    CGPathAddLineToPoint(pathRef, NULL, dirtyRect.origin.x + padding, dirtyRect.origin.y + padding);
    CGPathCloseSubpath(pathRef);
    
    if (highlight) {
        CGContextSetLineWidth(ctx, 5);
    }
    else {
        CGContextSetLineWidth(ctx, 2);
    }
    
    CGFloat dashValues[] = { 30, 20 };
    CGContextSetLineDash(ctx, 0, dashValues, 2);
    CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1);
    CGContextAddPath(ctx, pathRef);
    CGContextStrokePath(ctx);
    CGPathRelease(pathRef);


}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    
    highlight = NO;
    _arrowView.hidden = YES;
    [self setNeedsDisplay:YES];
    
    return  [NSImage canInitWithPasteboard:[sender draggingPasteboard]];
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    
    if ([sender draggingSource] != self) {
        NSURL *fileURL;
        
        if ([NSImage canInitWithPasteboard:[sender draggingPasteboard]]) {
            NSImage *newImage = [[NSImage alloc] initWithPasteboard:[sender draggingPasteboard]];
            [self setImage:newImage];
        }
        
        fileURL = [NSURL URLFromPasteboard:[sender draggingPasteboard]];
        
        // Call the 'dragDropped' callback if it is not null
        if(self.dragDroppedBlock != nil )
            self.dragDroppedBlock(fileURL);
    }
    
    return YES;
}

- (NSRect)windowWillUseStandardFrame:(NSWindow *)window defaultFrame:(NSRect)newFrame; {
    
    NSRect ContentRect = self.window.frame;
    
    ContentRect.size = [[self image]size];
    
    return [NSWindow frameRectForContentRect:ContentRect styleMask:[window styleMask]];
};

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    
    switch (context) {
        case NSDraggingContextOutsideApplication:
            return NSDragOperationCopy;
            
        case NSDraggingContextWithinApplication:
            
        default:
            return NSDragOperationCopy;
            break;
    }
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
    
    return YES;
}

- (void)pasteboard:(NSPasteboard *)pasteboard item:(NSPasteboardItem *)item provideDataForType:(NSString *)type {
    
    if ([type compare:NSPasteboardTypeTIFF] == NSOrderedSame) {
        [pasteboard setData:[[self image] TIFFRepresentation] forType:NSPasteboardTypeTIFF];
    } else if ([type compare:NSPasteboardTypePDF] == NSOrderedSame) {
        
        [pasteboard setData:[self dataWithEPSInsideRect:[self bounds]] forType:NSPasteboardTypePDF];
    }
}

@end
