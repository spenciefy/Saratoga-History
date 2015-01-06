//
//  SYFullAudioPlayerView.h
//  Saratoga History
//
//  Created by Spencer Yen on 1/4/15.
//  Copyright (c) 2015 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef enum : NSUInteger {
    StopAudioReset,
    StopAudioPause,
} StopAudio;

@protocol SYFullAudioPlayerViewDelegate;

@interface SYFullAudioPlayerView : UIView <AVAudioPlayerDelegate>

@property (nonatomic, weak) id<SYFullAudioPlayerViewDelegate> delegate;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) UILabel       *currentTime;
@property (strong, nonatomic) UILabel       *endTime;
@property (strong, nonatomic) UISlider      *seekBar;
@property (strong, nonatomic) UIButton      *playButton;
@property (strong, nonatomic) UIButton      *stopButton;
@property (strong, nonatomic) UIButton      *nextButton;
@property (strong, nonatomic) UIButton      *previousButton;
@property (assign, nonatomic) StopAudio     stopAudio;
@property (assign, nonatomic) BOOL          autoplay;

- (id)initWithFrame:(CGRect)frame audioFileURL:(NSURL *)fileURL autoplay:(BOOL)autoplay;
- (void)cleanUp;
- (void)stopAudio:(id)sender;

@end

@protocol SYFullAudioPlayerViewDelegate <NSObject>

-(void)nextTrack;
-(void)previousTrack;

@end
