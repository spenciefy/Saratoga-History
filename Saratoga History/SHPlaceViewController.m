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
    UITextView *textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 12;
    self.view.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pause)
                                                 name:@"PageViewChange"
                                               object:nil];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 15, 40)];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:22.0f];
    titleLabel.center = CGPointMake(self.view.frame.size.width/2, 25);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = self.place.placeTitle;
    [self.view addSubview:titleLabel];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"I Need A Dollar" ofType:@"mp3"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    SYAudioPlayerView *audioPlayer = [[SYAudioPlayerView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width - 10, 45) audioFileURL:fileURL autoplay:NO];
    audioPlayer.center = CGPointMake(self.view.frame.size.width/2, 48);
    [self.view addSubview:audioPlayer];
    
    self.audioVC.view.progressView.foregroundColor = [UIColor colorWithRed:88/255. green:199/255. blue:226/255. alpha:1];
    self.audioVC.view.progressView.backgroundColor = [UIColor colorWithWhite:207/255. alpha:1];
    self.audioVC.view.backgroundColor = [UIColor colorWithWhite:238/255. alpha:1];
    self.audioVC.view.playbackTimeLabel.textColor = [UIColor colorWithWhite:102/255. alpha:1];
    self.audioVC.view.titleLabel.textColor = [UIColor colorWithWhite:102/255. alpha:1];
    [self.audioVC playAudioWithURL:self.place.audioURLAsset.URL];

    
    scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, audioPlayer.frame.origin.y + audioPlayer.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - audioPlayer.frame.origin.y + audioPlayer.frame.size.height)];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    
    EScrollerView *imageScroller = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, self.view.frame.size.width, 200)ImageArray: self.place.images TitleArray: self.place.imageCaptions];
    imageScroller.delegate = self;
    [scrollView addSubview:imageScroller];
    
    textView = [[UITextView alloc] initWithFrame: self.view.frame];
    textView.frame = CGRectMake(textView.frame.origin.x, imageScroller.frame.origin.y + imageScroller.frame.size.height + 10, textView.frame.size.width, textView.frame.size.height);
    [textView setScrollEnabled:NO];
    textView.backgroundColor = [UIColor blueColor];
    [scrollView addSubview: textView];
    NSLog(@"%f", textView.frame.size.height + textView.frame.origin.y);
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, textView.frame.origin.y + textView.frame.size.height + 10);
    NSLog(@"%f", scrollView.frame.size.height);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (void)pause {
    [self.playerView stopAudio:self];
}

- (IBAction)expand:(id)sender {
}
@end