//
//  SHBaseViewController.h
//  Saratoga History
//
//  Created by Spencer Yen on 12/19/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHPlaceViewController.h"
#import "SHPlace.h"
#import <MapKit/MapKit.h>
#import "SHPlaceManager.h"

@interface SHBaseViewController : UIViewController <MKMapViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate,CLLocationManagerDelegate, UIGestureRecognizerDelegate, SHPlaceViewControllerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIView *menuBarView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UIPageViewController *pageViewController;

- (IBAction)resetMapRegion:(id)sender;
@end
