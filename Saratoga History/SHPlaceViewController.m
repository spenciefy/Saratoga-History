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

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, 40)];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:22.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = self.place.placeTitle;
    [self.view addSubview:titleLabel];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"I Need A Dollar" withExtension:@"mp3"] options:nil];
    self.playerView = [[SYWaveformPlayerView alloc] initWithFrame:CGRectMake(3,41,self.view.frame.size.width - 10, 45) asset:asset color:[UIColor lightGrayColor] progressColor:[UIColor colorWithRed:1 green:0.2 blue:0.2 alpha:1]];
    [self.view addSubview:self.playerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(pause)
                                        name:@"PageViewChange"
                                        object:nil];
    
    scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, self.playerView.frame.origin.y + self.playerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.playerView.frame.origin.y + self.playerView.frame.size.height)];
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
    [self.playerView pause];
}

- (IBAction)expand:(id)sender {
}
@end
