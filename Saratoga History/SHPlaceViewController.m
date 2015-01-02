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

    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, 40)];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:22.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = self.place.placeTitle;
    [scrollView addSubview:titleLabel];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"I Need A Dollar" withExtension:@"mp3"] options:nil];

    
    self.playerView = [[SYWaveformPlayerView alloc] initWithFrame:CGRectMake(3,41,self.view.frame.size.width - 10, 45) asset:asset color:[UIColor lightGrayColor] progressColor:[UIColor colorWithRed:1 green:0.2 blue:0.2 alpha:1]];
    [scrollView addSubview:self.playerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pause)
                                                 name:@"PageViewChange"
                                               object:nil];
    
    EScrollerView *imageScroller = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 90, self.view.frame.size.width, 200)
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
    [self.playerView pause];
}

- (IBAction)expand:(id)sender {
}
@end
