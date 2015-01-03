//
//  SYAudioPlayerView.h
//  Saratoga History
//
//  Created by Spencer Yen on 1/2/15.
//  Copyright (c) 2015 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/**
 This enum is used to set the behaviour of the stop button. The default mode (i.e. if the StopAudio variable
 isn't set) is to use StopAudioPause. StopAudioPause pauses playback when stop is pressed and resumes from the
 same position when play is pressed. StopAudioReset stops the audio when stop is pressed and resets the playback
 position to 0.0seconds. Playback would resume from the start.
 */

typedef enum : NSUInteger {
    StopAudioReset,
    StopAudioPause,
} StopAudio;

@interface SYAudioPlayerView : UIView <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) UILabel       *currentTime;
@property (strong, nonatomic) UILabel       *endTime;
@property (strong, nonatomic) UISlider      *seekBar;
@property (strong, nonatomic) UIButton      *playButton;
@property (strong, nonatomic) UIButton      *stopButton;
@property (assign, nonatomic) StopAudio     stopAudio;
@property (assign, nonatomic) BOOL          autoplay;

- (id)initWithFrame:(CGRect)frame audioFileURL:(NSURL *)fileURL autoplay:(BOOL)autoplay;
- (void)cleanUp;
- (void)stopAudio:(id)sender;

@end
