//
//  GPSViewController.m
//  GPS Exif Demo
//
//  Created by Baris Atamer on 18/04/16.
//  Copyright © 2016 Baris Atamer. All rights reserved.
//

#import "GPSViewController.h"
#import "ExifLocationReader.h"

@interface GPSViewController ()

@end

@implementation GPSViewController
{
    NSURL *_droppedImageURL;
    NSPopover *_popOver;
    CLLocation *_location;
    MKPointAnnotation *_annotation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.dragDropImageView setDragDroppedBlock:^(NSURL *fileURL) {
        
        _droppedImageURL = fileURL;
        
        // Get GPS dictionary
        NSDictionary *gpsDictionary = [ExifLocationReader gpsDictionaryOfFile:fileURL];
        NSLog(@"GPS Dictionary is : %@", gpsDictionary);
        NSLog(@"lat:  %@", gpsDictionary[(NSString*)kCGImagePropertyGPSLatitude]);
        
        // Clear the UI
        [self.tfAltitude        setStringValue:@""];
        [self.tfDOP             setStringValue:@""];
        [self.tfLatitude        setStringValue:@""];
        [self.tfLatitudeRef     setStringValue:@""];
        [self.tfLongitude       setStringValue:@""];
        [self.tfLongitudeRef    setStringValue:@""];
        
        // Set into UI
        if (gpsDictionary != nil) {
            
            [self.tfAltitude     setStringValue:gpsDictionary[(NSString*)kCGImagePropertyGPSAltitude]];
            [self.tfDOP          setStringValue:gpsDictionary[(NSString*)kCGImagePropertyGPSDOP]];
            [self.tfLatitude     setStringValue:gpsDictionary[(NSString*)kCGImagePropertyGPSLatitude]];
            [self.tfLatitudeRef  setStringValue:gpsDictionary[(NSString*)kCGImagePropertyGPSLatitudeRef]];
            [self.tfLongitude    setStringValue:gpsDictionary[(NSString*)kCGImagePropertyGPSLongitude]];
            [self.tfLongitudeRef setStringValue:gpsDictionary[(NSString*)kCGImagePropertyGPSLongitudeRef]];
            
            
            CLLocationDegrees latitude  = [gpsDictionary[(NSString*)kCGImagePropertyGPSLatitude]  doubleValue];
            CLLocationDegrees longitude = [gpsDictionary[(NSString*)kCGImagePropertyGPSLongitude] doubleValue];
            
            // Refs
            if ( [gpsDictionary[(NSString*)kCGImagePropertyGPSLatitudeRef] isEqualToString:@"S"] ) {
                latitude *= -1.0f;
            }
            if ([gpsDictionary[(NSString*)kCGImagePropertyGPSLatitudeRef] isEqualToString:@"W"]) {
                longitude *= -1.0f;
            }
            
            _location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            
            [self setLocationInMap:_location];
        }
        
    }];
    
}

- (void) setLocationInMap:(CLLocation*) location {
    
    _annotation = [[MKPointAnnotation alloc]init];
    _annotation.coordinate = location.coordinate;
    _annotation.title = @"Photo";
    
    MKCoordinateRegion region;
    region.center = location.coordinate;
    region.span = MKCoordinateSpanMake(0.1, 0.1);
    
    
    [self.mapView setRegion:region];
    [self.mapView addAnnotation:_annotation];
    [self.mapView setHidden:NO];
}

- (void)mouseUp:(NSEvent *)theEvent {
    
    CGPoint touchPoint = theEvent.locationInWindow;
    
    CLLocationCoordinate2D touchCoordinate = [self.mapView convertPoint:touchPoint
                                                   toCoordinateFromView:self.view];
    
    NSLog(@"%f, %f", touchCoordinate.latitude, touchCoordinate.longitude);
    
    _annotation.coordinate = touchCoordinate;
}

@end
