//
//  SHPlaceManager.h
//  Saratoga History
//
//  Created by Spencer Yen on 12/26/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHPlace.h"
#import <Parse/Parse.h>

@interface SHPlaceManager : NSObject

+ (SHPlaceManager *)sharedInstance;

- (void)placesWithCompletion:(void (^)(NSArray *placesArray, NSError *error))completionBlock;

- (void)uploadPhotos:(PFFile *)photos withCaptions:(NSArray *)captions toObjectID:(NSString *)oID;

@end
