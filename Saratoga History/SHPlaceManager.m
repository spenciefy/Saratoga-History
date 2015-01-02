//
//  SHPlaceManager.m
//  Saratoga History
//
//  Created by Spencer Yen on 12/26/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHPlaceManager.h"
#import <Parse/Parse.h>
#import "Reachability.h"

@implementation SHPlaceManager

+ (SHPlaceManager *)sharedInstance {
    static SHPlaceManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SHPlaceManager alloc] init];
        
    });
    return _sharedInstance;
}

- (void)placesWithCompletion:(void (^)(NSArray *placesArray, NSError *error))completionBlock {

    NSMutableArray *places = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Places"];
    if(![self hasNetwork]) {
        [query fromLocalDatastore];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            float lat = [object[@"Latitude"] floatValue];
            float lng = [object[@"Longitude"] floatValue];
            int index = [object[@"Index"] intValue];
            
            PFFile *imagesFile =  (PFFile *)object[@"Images"];
            NSArray *images = [NSKeyedUnarchiver unarchiveObjectWithData:[imagesFile getData]];
            PFFile *audioFile  = (PFFile *)object[@"audio"];
            SHPlace *place = [[SHPlace alloc]initWithIndex:index title:object[@"Title"] lat:lat lng:lng address:object[@"Address"] descriptionText:object[@"Description"] images:images imageCaptions:object[@"ImageCaptions"] audio:[audioFile getData]];
            [places addObject:place];
                
            if(places.count == objects.count) {
                completionBlock([places mutableCopy], nil);
            }
          //  [object pinInBackground];
            
        }
    }];
}

- (void)uploadPhotos:(PFFile *)photos withCaptions:(NSArray *)captions toObjectID:(NSString *)oID {
    PFQuery *query = [PFQuery queryWithClassName:@"Places"];
    [query getObjectInBackgroundWithId:oID block:^(PFObject *place, NSError *error) {
        place[@"Images"] = photos;
        place[@"ImageCaptions"] = captions;
        [place saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
                NSLog(@"succeeded");
            if (error)
                NSLog(@"error: %@", error.description);
        }];
    }];
}

- (BOOL)hasNetwork {
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    
    if(myStatus == NotReachable) {
        return NO;
    } else{
        return YES;
    }
}


@end