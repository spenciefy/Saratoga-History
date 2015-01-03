//
//  SHPlace.h
//  Saratoga History
//
//  Created by Spencer Yen on 12/26/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JPSThumbnailAnnotation.h>
#import "SYWaveformPlayerView.h"

@interface SHPlace : NSObject

@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSString *placeTitle;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *imageCaptions;
@property (nonatomic, strong) JPSThumbnail *annotationThumbnail;
@property (nonatomic, strong) AVURLAsset *audioURLAsset;

-(id)initWithIndex:(int)indx title:(NSString *)title lat:(float)latitude lng:(float)longitude address:(NSString *)addres descriptionText:(NSString *)text images:(NSArray *)imgs imageCaptions:(NSArray *)captions audio:(AVURLAsset *)audioAsset;


@end

