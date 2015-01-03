//
//  SHPlaceViewController.m
//  Saratoga History
//
//  Created by Spencer Yen on 12/26/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHPlaceViewController.h"
#import "EScrollerView.h"

@interface SHPlaceViewController () <EScrollerViewDelegate>

@end

@implementation SHPlaceViewController {
    UIScrollView *scrollView;
    UILabel *titleLabel;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 12;
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    //    scrollView.contentSize = CGSizeMake(width,height);
    
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 15, 40)];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:22.0f];
    titleLabel.center = CGPointMake(self.view.frame.size.width/2, 25);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = self.place.placeTitle;
    [scrollView addSubview:titleLabel];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"I Need A Dollar" ofType:@"mp3"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    SYAudioPlayerView *audioPlayer = [[SYAudioPlayerView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width - 10, 45)
                                                                 audioFileURL:fileURL
                                                                     autoplay:NO];
    audioPlayer.center = CGPointMake(self.view.frame.size.width/2, 48);
    [scrollView addSubview:audioPlayer];
    
    self.audioVC.view.progressView.foregroundColor = [UIColor colorWithRed:88/255. green:199/255. blue:226/255. alpha:1];
    self.audioVC.view.progressView.backgroundColor = [UIColor colorWithWhite:207/255. alpha:1];
    self.audioVC.view.backgroundColor = [UIColor colorWithWhite:238/255. alpha:1];
    self.audioVC.view.playbackTimeLabel.textColor = [UIColor colorWithWhite:102/255. alpha:1];
    self.audioVC.view.titleLabel.textColor = [UIColor colorWithWhite:102/255. alpha:1];
    [self.audioVC playAudioWithURL:self.place.audioURLAsset.URL];
    
    EScrollerView *imageScroller = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 75, self.view.frame.size.width, 200)
                                                                 ImageArray:self.place.images
                                                                 TitleArray:self.place.imageCaptions];
    imageScroller.delegate = self;
    [self.view addSubview:imageScroller];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pause {
    [self.playerView stopAudio:self];
}

- (IBAction)expand:(id)sender {
}
@end