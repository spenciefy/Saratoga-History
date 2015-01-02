//
//  SYWaveformPlayerView.h
//  SCWaveformView
//
//  Created by Spencer Yen on 12/26/14.
//  Copyright (c) 2014 Simon CORSIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SCWaveformView.h"

@interface SYWaveformPlayerView : UIView  <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;

- (void)play;
- (void)pause;

- (id)initWithFrame:(CGRect)frame asset:(AVURLAsset *)asset color:(UIColor *)normalColor progressColor:(UIColor *)progressColor;

@end
