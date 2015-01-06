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
    UIScrollView *_scrollView;
    UILabel *_titleLabel;
    UITextView *_textView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.expanded = NO;
    self.view.layer.cornerRadius = 12;
    self.view.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pause)
                                                 name:@"PageViewChange"
                                               object:nil];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 15, 40)];
    _titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:22.0f];
    _titleLabel.center = CGPointMake(self.view.frame.size.width/2, 25);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = self.place.placeTitle;
    [self.view addSubview:_titleLabel];
    
    SYAudioPlayerView *audioPlayer = [[SYAudioPlayerView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width - 10, 45) audioFileURL:self.place.audioURLAsset.URL autoplay:NO];
    audioPlayer.center = CGPointMake(self.view.frame.size.width/2, 48);
    
    if(self.showsAudioView) {
        [self.view addSubview:audioPlayer];
        _scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, audioPlayer.frame.origin.y + audioPlayer.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 130)];
    } else {
        _scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, audioPlayer.frame.origin.y + audioPlayer.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 82)];
    }

    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    EScrollerView *imageScroller = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, self.view.frame.size.width, 170) ImageArray: self.place.images TitleArray: self.place.imageCaptions];
    imageScroller.delegate = self;
    [_scrollView addSubview:imageScroller];
    
    _textView = [[UITextView alloc] initWithFrame: self.view.frame];
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:self.place.descriptionText attributes:@{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:17]}];
    _textView.frame = CGRectMake(8, imageScroller.frame.origin.y + imageScroller.frame.size.height + 10, self.view.frame.size.width - 16, [self textViewHeightForAttributedText:text andWidth:self.view.frame.size.width-16]);
    _textView.scrollEnabled = NO;
    _textView.editable = NO;
    _textView.text = self.place.descriptionText;
    _textView.font = [UIFont fontWithName:@"AvenirNext-Regular" size:17];
    _textView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview: _textView];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _textView.frame.origin.y + _textView.frame.size.height);
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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_delegate respondsToSelector:@selector(scrollViewDidScroll:placeView:)]) {
        [_delegate scrollViewDidScroll:scrollView placeView:self];
    }
}
-(CGSize) getContentSize:(UITextView*) myTextView{
    return [myTextView sizeThatFits:CGSizeMake(myTextView.frame.size.width, FLT_MAX)];
}


@end