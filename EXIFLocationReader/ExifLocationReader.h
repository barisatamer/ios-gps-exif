//
//  ExifLocationReader.h
//  Exif Location Reader
//
//  Created by Baris Atamer on 15/04/16.
//  Copyright © 2016 Baris Atamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExifLocationReader : NSObject

+ (NSDictionary*) gpsDictionaryOfFile:(NSURL*) imageFileURL;

+ (void) setGPS:(NSDictionary*) gpsDictionary withFileURL:(NSURL*) fileURL;

@end
