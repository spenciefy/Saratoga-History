//
//  SHPlaceViewController.h
//  Saratoga History
//
//  Created by Spencer Yen on 12/26/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHPlace.h"
#import "SYAudioPlayerView.h"

@interface SHPlaceViewController : UIViewController

@property (strong, nonatomic) SHPlace *place;
@property (nonatomic, assign) int pageIndex;

@property (strong, nonatomic) SYAudioPlayerView *playerView;

- (IBAction)expand:(id)sender;
- (void)pause;

@end
