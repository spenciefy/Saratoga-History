//
//  SHPlaceViewController.h
//  Saratoga History
//
//  Created by Spencer Yen on 12/26/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHPlace.h"
#import "SYWaveformPlayerView.h"

@interface SHPlaceViewController : UIViewController

@property (strong, nonatomic) SHPlace *place;
@property (nonatomic, assign) int pageIndex;

@property (strong, nonatomic) SYWaveformPlayerView *playerView;

- (IBAction)expand:(id)sender;
@end
