//
//  DragDropImageView.h
//  BA_Icon_Generator
//
//  Created by Baris Atamer on 4/11/16.
//  Copyright © 2016 barisatamer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void (^onDragDropped) (NSURL* fileURL);

@interface DragDropImageView : NSImageView <NSDraggingSource, NSDraggingDestination, NSPasteboardItemDataProvider>
{
    BOOL highlight;
}

// On Drag & Drop Block
@property (copy) onDragDropped dragDroppedBlock;
- (void)setDragDroppedBlock:(onDragDropped) dragDroppedBlock;

- (id) initWithCoder:(NSCoder *)coder;

@end
