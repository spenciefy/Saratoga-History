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

@protocol SHPlaceViewControllerDelegate;

@interface SHPlaceViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) id<SHPlaceViewControllerDelegate> delegate;
@property (strong, nonatomic) SHPlace *place;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) BOOL expanded;

@property (strong, nonatomic) SYAudioPlayerView *playerView;

- (void)pause;

@end

@protocol SHPlaceViewControllerDelegate <NSObject>

-(void)scrollViewDidScroll:(UIScrollView *)scrollView placeView:(SHPlaceViewController *)placeVC;

@end
