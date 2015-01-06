//
//  SYFullAudioPlayerView.m
//  Saratoga History
//
//  Created by Spencer Yen on 1/4/15.
//  Copyright (c) 2015 Spencer Yen. All rights reserved.
//

#import "SYFullAudioPlayerView.h"
#import "UIView+AutoLayout.h"

@implementation SYFullAudioPlayerView

- (id)initWithFrame:(CGRect)frame audioFileURL:(NSURL *)fileURL autoplay:(BOOL)autoplay
{
    self = [super initWithFrame:frame];
    self.autoplay = autoplay;
    
    // Setup audioPlayer
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [_audioPlayer prepareToPlay];
    
    // Setup buttons
    _playButton = [UIButton new];
    _playButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setImage:[UIImage imageNamed:@"playBlack.png"] forState:UIControlStateNormal];
    [self addSubview:_playButton];
    
    _stopButton = [UIButton new];
    _stopButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_stopButton addTarget:self action:@selector(stopAudio:) forControlEvents:UIControlEventTouchUpInside];
    [_stopButton setImage:[UIImage imageNamed:@"pauseBlack.png"] forState:UIControlStateNormal];
    [self.stopButton setHidden:YES];
    [self addSubview:_stopButton];
    
    _previousButton = [UIButton new];
    _previousButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_previousButton addTarget:self action:@selector(previousTrack) forControlEvents:UIControlEventTouchUpInside];
    [_previousButton setImage:[UIImage imageNamed:@"previousBlack.png"] forState:UIControlStateNormal];
    [self.previousButton setHidden:YES];
    [self addSubview:_previousButton];
    
    _nextButton = [UIButton new];
    _nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_nextButton addTarget:self action:@selector(nextTrack) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setImage:[UIImage imageNamed:@"nextBlack.png"] forState:UIControlStateNormal];
    [self.nextButton setHidden:YES];
    [self addSubview:_nextButton];
    
    // Setup seekbar
    _seekBar = [UISlider new];
    _seekBar.translatesAutoresizingMaskIntoConstraints = NO;
    [_seekBar addTarget:self action:@selector(updateSlider:) forControlEvents:UIControlEventValueChanged];
    _seekBar.minimumValue = 0.0;
    _seekBar.maximumValue = _audioPlayer.duration;
    _seekBar.value = 0.0;
    CGRect rect = CGRectMake(0, 0, 1, 3);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[UIColor lightGrayColor] setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_seekBar setMinimumTrackImage:image forState:UIControlStateNormal];
    [_seekBar setMinimumTrackImage:image forState:UIControlStateNormal];
    
    [_seekBar setThumbImage:[self thumbImageForColor:[UIColor colorWithRed:211/255.0 green:84/255.0 blue:0/255.0 alpha:1.0]] forState:UIControlStateNormal];
    [_seekBar setThumbImage:[self thumbImageForColor:[UIColor colorWithRed:211/255.0 green:84/255.0 blue:0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    
    [self addSubview:_seekBar];
    
    // Setup labels
    _currentTime = [UILabel new];
    _currentTime.translatesAutoresizingMaskIntoConstraints = NO;
    _currentTime.text = @"0:00";
    _currentTime.textColor = [UIColor blackColor];
    _currentTime.textAlignment = NSTextAlignmentLeft;
    _currentTime.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [self addSubview:_currentTime];
    
    _endTime = [UILabel new];
    _endTime.translatesAutoresizingMaskIntoConstraints = NO;
    NSTimeInterval totalTime = self.audioPlayer.duration;
    int min1= totalTime/60;
    int sec1= lroundf(totalTime) % 60;
    
    NSString *secStr1 = [NSString stringWithFormat:@"%d", sec1];
    if (secStr1.length == 1) {
        secStr1 = [NSString stringWithFormat:@"0%d", sec1];
    }
    _endTime.text = [NSString stringWithFormat:@"-%d:%@", min1, secStr1];
    _endTime.textColor = [UIColor blackColor];
    _endTime.textAlignment = NSTextAlignmentRight;
    _endTime.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [self addSubview:_endTime];
    
    /*
     *  Setup views using autolayout. Pin labels and status bar to the bottom of the view and
     *  pin the play and stop buttons to the top of the view.
     */
    
    
    [self.seekBar pinToSuperviewEdges:JRTViewPinBottomEdge inset:10];
    [self.seekBar constrainToWidth:self.frame.size.width-30];
    [self.seekBar pinToSuperviewEdges:JRTViewPinLeftEdge inset:25];
    
    [self.endTime pinAttribute:NSLayoutAttributeCenterY toAttribute:NSLayoutAttributeCenterY ofItem:self.seekBar];
    [self.endTime pinToSuperviewEdges:JRTViewPinRightEdge inset:10];
    [self.endTime constrainToWidth:30];
    
    [self.currentTime pinAttribute:NSLayoutAttributeCenterY toAttribute:NSLayoutAttributeCenterY ofItem:self.seekBar];
    [self.currentTime pinToSuperviewEdges:JRTViewPinLeftEdge inset:10];
    [self.currentTime constrainToWidth:30];
    
    [self.playButton pinAttribute:NSLayoutAttributeCenterX toAttribute:NSLayoutAttributeCenterX ofItem:self];
    [self.playButton pinToSuperviewEdges:JRTViewPinTopEdge inset:10];
    [self.playButton constrainToWidth:50.0];
    [self.playButton constrainToHeight:50.0];
    
    [self.stopButton pinAttribute:NSLayoutAttributeCenterY toAttribute:NSLayoutAttributeCenterY ofItem:self.seekBar];
    [self.stopButton pinToSuperviewEdges:JRTViewPinTopEdge inset:10];
    [self.stopButton constrainToWidth:50.0];
    [self.stopButton constrainToHeight:50.0];
    
    [self.nextButton pinAttribute:NSLayoutAttributeCenterY toAttribute:NSLayoutAttributeCenterY ofItem:self.playButton];
    [self.nextButton pinToSuperviewEdges:JRTViewPinLeftEdge inset:5];
    [self.nextButton pinEdges:JRTViewPinLeftEdge toSameEdgesOfView:self.playButton inset:30];
    [self.nextButton constrainToWidth:50.0];
    [self.nextButton constrainToHeight:50.0];
    
    [self.previousButton pinAttribute:NSLayoutAttributeCenterY toAttribute:NSLayoutAttributeCenterY ofItem:self.playButton];
    [self.previousButton pinEdges:JRTViewPinRightEdge toSameEdgesOfView:self.playButton inset:30];
    [self.previousButton constrainToWidth:50.0];
    [self.previousButton constrainToHeight:50.0];
    
    //Autoplay
    if (self.autoplay == YES) {
        self.playButton.hidden = YES;
        self.stopButton.hidden = NO;
        [self.audioPlayer play];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    }
    
    return self;
}

- (void)updateTime:(NSTimer *)timer
{
    NSTimeInterval timePassed = self.audioPlayer.currentTime;
    int min= timePassed/60;
    int sec= lroundf(timePassed) % 60;
    NSTimeInterval totalTime = self.audioPlayer.duration;
    int min1= totalTime/60;
    int sec1= lroundf(totalTime-timePassed) % 60;
    
    // If seconds is under 10 put a zero before the second value
    NSString *secStr = [NSString stringWithFormat:@"%d", sec];
    if (secStr.length == 1) {
        secStr = [NSString stringWithFormat:@"0%d", sec];
    }
    
    NSString *secStr1 = [NSString stringWithFormat:@"%d", sec1];
    if (secStr1.length == 1) {
        secStr1 = [NSString stringWithFormat:@"0%d", sec1];
    }
    
    self.currentTime.text = [NSString stringWithFormat:@"%d:%@", min, secStr];
    self.endTime.text = [NSString stringWithFormat:@"-%d:%@", min1, secStr1];
    
    self.seekBar.value = self.audioPlayer.currentTime;
    if (self.audioPlayer.currentTime == self.audioPlayer.duration) {
        self.playButton.hidden = NO;
        self.stopButton.hidden = YES;
        [timer invalidate];
    }
}

- (void)updateSlider:(id)sender
{
    self.audioPlayer.currentTime = self.seekBar.value;
    
    NSTimeInterval timePassed = self.audioPlayer.currentTime;
    int min= timePassed/60;
    int sec= lroundf(timePassed) % 60;
    NSTimeInterval totalTime = self.audioPlayer.duration;
    int min1= totalTime/60;
    int sec1= lroundf(totalTime-timePassed) % 60;
    
    // If seconds is under 10 put a zero before the second value
    NSString *secStr = [NSString stringWithFormat:@"%d", sec];
    if (secStr.length == 1) {
        secStr = [NSString stringWithFormat:@"0%d", sec];
    }
    
    NSString *secStr1 = [NSString stringWithFormat:@"%d", sec1];
    if (secStr1.length == 1) {
        secStr1 = [NSString stringWithFormat:@"0%d", sec1];
    }
    
    self.currentTime.text = [NSString stringWithFormat:@"%d:%@", min, secStr];
    self.endTime.text = [NSString stringWithFormat:@"-%d:%@", min1, secStr1];
}

- (void)playAudio:(id)sender
{
    if (![self.audioPlayer isPlaying]) {
        self.playButton.hidden = YES;
        self.stopButton.hidden = NO;
        [self.audioPlayer play];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    }
}

- (void)stopAudio:(id)sender
{
    self.stopAudio = StopAudioPause;
    if ([self.audioPlayer isPlaying]) {
        if (self.stopAudio != StopAudioReset && self.stopAudio != StopAudioPause) {
            //If enum hasn't been set default to StopAudioPause
            self.stopAudio = StopAudioPause;
            [self.audioPlayer pause];
        } else if (self.stopAudio == StopAudioReset) {
            [self.audioPlayer setCurrentTime:0.0];
            [self.audioPlayer stop];
        } else if (self.stopAudio == StopAudioPause) {
            [self.audioPlayer pause];
        }
        
        self.stopButton.hidden = YES;
        self.playButton.hidden = NO;
    }
}

- (void)nextTrack
{
    if ([_delegate respondsToSelector:@selector(nextTrack)]) {
        [_delegate nextTrack];
    }
}


- (void)previousTrack
{
    if ([_delegate respondsToSelector:@selector(previousTrack)]) {
        [_delegate previousTrack];
    }
}

- (void)cleanUp
{
    [self.audioPlayer stop];
}

-(UIImage *)thumbImageForColor:(UIColor *)color {
    CGSize imageSize = CGSizeMake(3, 15);
    UIColor *fillColor = color;
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [fillColor setFill];
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
