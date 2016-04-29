//
//  AppDelegate.m
//  GPS Exif Demo
//
//  Created by Baris Atamer on 15/04/16.
//  Copyright © 2016 Baris Atamer. All rights reserved.
//

#import "AppDelegate.h"
#import "DragDropImageView.h"
#import "ExifLocationReader.h"
#import "GPSViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet DragDropImageView *dragDropImageView;

@property (weak) IBOutlet NSTextField *tfAltitude;
@property (weak) IBOutlet NSTextField *tfDOP;
@property (weak) IBOutlet NSTextField *tfLatitude;
@property (weak) IBOutlet NSTextField *tfLatitudeRef;
@property (weak) IBOutlet NSTextField *tfLongitude;
@property (weak) IBOutlet NSTextField *tfLongitudeRef;


@end

@implementation AppDelegate
{
    NSURL *_droppedImageURL;
    NSPopover *_popOver;
    CLLocation *_location;
    MKPointAnnotation *_annotation;
    GPSViewController *_gpsVC;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Create and add the GPSViewController to the window
    _gpsVC = [[GPSViewController alloc] initWithNibName:@"GPSViewController" bundle:nil];
    _gpsVC.view.frame = self.window.contentView.frame;
    [self.window.contentView addSubview:_gpsVC.view];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
