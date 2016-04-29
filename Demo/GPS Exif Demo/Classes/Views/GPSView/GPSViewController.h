//
//  GPSViewController.h
//  GPS Exif Demo
//
//  Created by Baris Atamer on 18/04/16.
//  Copyright © 2016 Baris Atamer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Mapkit/Mapkit.h>
#import "DragDropImageView.h"

@interface GPSViewController : NSViewController

@property (weak) IBOutlet DragDropImageView *dragDropImageView;

@property (weak) IBOutlet NSTextField *tfAltitude;
@property (weak) IBOutlet NSTextField *tfDOP;
@property (weak) IBOutlet NSTextField *tfLatitude;
@property (weak) IBOutlet NSTextField *tfLatitudeRef;
@property (weak) IBOutlet NSTextField *tfLongitude;
@property (weak) IBOutlet NSTextField *tfLongitudeRef;
@property (weak) IBOutlet MKMapView *mapView;

@end
