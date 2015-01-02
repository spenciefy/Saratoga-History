//
//  SHPlace.m
//  Saratoga History
//
//  Created by Spencer Yen on 12/26/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHPlace.h"
#import <Parse/Parse.h>

@implementation SHPlace

-(id)initWithIndex:(int)indx title:(NSString *)title lat:(float)latitude lng:(float)longitude address:(NSString *)addres descriptionText:(NSString *)text images:(NSArray *)imgs imageCaptions:(NSArray *)captions audio:(NSData *)audioData {
    self = [super init];
    if(self) {
       
        self.index = indx;
        self.placeTitle = title;
        self.lat = latitude;
        self.lng = longitude;
        self.address = addres;
        self.descriptionText = text;
        self.images = imgs;
        self.imageCaptions = captions;
        self.audio = audioData;
        
        self.annotationThumbnail = [[JPSThumbnail alloc] init];
        UIImage *image = [UIImage imageWithData:[imgs firstObject]];
        self.annotationThumbnail.image = image;
        self.annotationThumbnail.title = self.placeTitle;
        self.annotationThumbnail.subtitle = [self.imageCaptions firstObject];
        self.annotationThumbnail.coordinate = CLLocationCoordinate2DMake(self.lat, self.lng);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        [documentsDirectory stringByAppendingPathComponent:self.placeTitle];
        
        // Make sure there is no other file with the same name first
        if ([[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
            [[NSFileManager defaultManager] removeItemAtPath:documentsDirectory error:nil];
        }
        
        [audioData writeToFile:documentsDirectory atomically:NO];
        self.audioURLAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:documentsDirectory] options:nil];

    }    
    return self;
}

@end
