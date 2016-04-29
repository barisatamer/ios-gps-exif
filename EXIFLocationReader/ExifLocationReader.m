//
//  ExifLocationReader.m
//  GPS Exif Demo
//
//  Created by Baris Atamer on 15/04/16.
//  Copyright © 2016 Baris Atamer. All rights reserved.
//

#import "ExifLocationReader.h"
#import <ImageIO/ImageIO.h>

@implementation ExifLocationReader

+ (NSDictionary*) gpsDictionaryOfFile:(NSURL*) imageFileURL {
    
    NSDictionary *gpsDictionary;
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)imageFileURL, NULL);
    
    if (imageSource == NULL) {
        // Error loading image
        NSLog(@"Error loading image ");
        return nil;
    }
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache,
                             nil];
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (CFDictionaryRef)options);
    
    //    NSLog(@"Image properties is %@", imageProperties);
    
    if (imageProperties) {
        NSNumber *width  = (NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
        NSNumber *height = (NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
        NSLog(@"Image dimensions: %@ x %@ px", width, height);
    }
    
    
    // Read GPS
    CFDictionaryRef gps = CFDictionaryGetValue(imageProperties, kCGImagePropertyGPSDictionary);
    
    NSLog(@"Gps data is %@", gps);
    
    if (gps) {
        NSString *latitudeString  = (NSString *)CFDictionaryGetValue(gps, kCGImagePropertyGPSLatitude);
        NSString *latitudeRef     = (NSString *)CFDictionaryGetValue(gps, kCGImagePropertyGPSLatitudeRef);
        NSString *longitudeString = (NSString *)CFDictionaryGetValue(gps, kCGImagePropertyGPSLongitude);
        NSString *longitudeRef    = (NSString *)CFDictionaryGetValue(gps, kCGImagePropertyGPSLongitudeRef);
        NSLog(@"GPS Coordinates: %@ %@ / %@ %@", longitudeString, longitudeRef, latitudeString, latitudeRef);
        
        gpsDictionary = (__bridge NSDictionary*)gps;
        
        CFRelease(imageProperties);
        CFRelease(gps);
    }
    else {
        NSLog(@"GPS is empty ");
    }
    
    return gpsDictionary;
}

+ (void) setGPS:(NSDictionary*) gpsDictionary withFileURL:(NSURL*) fileURL {
    
    // Create an Image I/O Compatible dictionary
//    NSDictionary *GPSDictionary = [ExifGeoManager gpsDictionaryForLocation:location];
    
    // Get the image properties of the image
    CFDictionaryRef imageProperties = [self imageProperties:fileURL];
    CFMutableDictionaryRef mutableImageProperties = CFDictionaryCreateMutableCopy(NULL, 0, imageProperties);
    
    // Set the given location
    CFDictionaryRef gpsRef = (__bridge CFDictionaryRef) gpsDictionary;
    CFDictionarySetValue(mutableImageProperties, kCGImagePropertyGPSDictionary, gpsRef);
    
    NSLog(@"Our Image properties is now : %@" , mutableImageProperties);
    
    // Create image data provider
    CGDataProviderRef imgDataProvider = CGDataProviderCreateWithURL( (CFURLRef) fileURL);
    CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
    
    
    // create the new output data
    CFMutableDataRef newImageData = CFDataCreateMutable(NULL, 0);
    // my code assumes JPEG type since the input is from the iOS device camera
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef) @"image/jpg", kUTTypeImage);
    // create the destination
    CGImageDestinationRef destination = CGImageDestinationCreateWithData(newImageData, type, 1, NULL);
    // add the image to the destination
    CGImageDestinationAddImage(destination, imageRef, mutableImageProperties);
    // finalize the write
    CGImageDestinationFinalize(destination);
    
    // memory cleanup
    //    CFRelease(mutableImageProperties);
    CFRelease(imageProperties);
    CFRelease(gpsRef);
    CGDataProviderRelease(imgDataProvider);
    CGImageRelease(imageRef);
    CFRelease(type);
    CFRelease(destination);
    
    // your new image data
    NSData *newImage = (__bridge_transfer NSData *)newImageData;
    
    // Write to disk
    [newImage writeToFile:[fileURL path] atomically:YES];

    
}

+ (CFDictionaryRef) imageProperties:(NSURL*) imageFileURL {
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)imageFileURL, NULL);
    
    if (imageSource == NULL) {
        // Error loading image
        NSLog(@"Error loading image ");
        return nil;
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache,
                             nil];
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (CFDictionaryRef)options);
    NSLog(@"Image properties are %@", imageProperties);
    return imageProperties;
}
@end
