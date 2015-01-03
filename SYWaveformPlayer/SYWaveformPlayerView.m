//
//  SYWaveformPlayerView.m
//  SCWaveformView
//
//  Created by Spencer Yen on 12/26/14.
//  Copyright (c) 2014 Simon CORSIN. All rights reserved.
//

#import "SYWaveformPlayerView.h"

@implementation SYWaveformPlayerView {
    SCWaveformView *waveformView;
    UIButton *playPauseButton;
}

- (id)initWithFrame:(CGRect)frame asset:(AVURLAsset *)asset color:(UIColor *)normalColor progressColor:(UIColor *)progressColor {
    if (self = [super initWithFrame:frame]) {
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:asset.URL error:nil];
        self.player.delegate = self;
        
        waveformView = [[SCWaveformView alloc] init];
        waveformView.normalColor = normalColor;
        waveformView.progressColor = progressColor;
        waveformView.alpha = 0.8;
        waveformView.backgroundColor = [UIColor clearColor];
        waveformView.asset = asset;
        [self addSubview:waveformView];
        
        playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playPauseButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:UIControlStateNormal];
        [playPauseButton addTarget:self
                   action:@selector(playPauseTapped)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playPauseButton];
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target: self
                                                          selector: @selector(updateWaveform:) userInfo: nil repeats: YES];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    playPauseButton.frame = CGRectMake(5, self.frame.size.height/2 - self.frame.size.height/4 , self.frame.size.height/1.8, self.frame.size.height/1.8);
    playPauseButton.layer.cornerRadius = self.frame.size.height/4;
    
    waveformView.frame = CGRectMake(self.frame.size.height/2 + 10, 0, self.frame.size.width - (self.frame.size.height/2 + 10), self.frame.size.height);
}

- (void)playPauseTapped{
    if(self.player.playing){
        [self pause];
    } else {
        [self play];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesMoved:touches withEvent:event];
    [self.player pause];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches]anyObject];
    CGPoint location = [touch locationInView:touch.view];
    if(location.x/self.frame.size.width > 0) {
        waveformView.progress = location.x/self.frame.size.width;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSTimeInterval newTime = waveformView.progress * self.player.duration;
    self.player.currentTime = newTime;
    [self play];
    
}

- (void)updateWaveform:(id)sender {
    
    if(self.player.playing) {
        waveformView.progress = self.player.currentTime/self.player.duration;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {
    [playPauseButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:UIControlStateNormal];
}

- (void)pause {
    [playPauseButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:UIControlStateNormal];
    [self.player pause];
}

- (void)play {
    [playPauseButton setImage:[UIImage imageNamed:@"pausebutton.png"] forState:UIControlStateNormal];
    [self.player play];

}
@end
