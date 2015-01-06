//
//  SHTourViewController.m
//  Saratoga History
//
//  Created by Spencer Yen on 1/4/15.
//  Copyright (c) 2015 Spencer Yen. All rights reserved.
//

#import "SHTourViewController.h"

@interface SHTourViewController () {
    NSArray *places;
    NSMutableArray *placeViewControllers;
    SHPlaceViewController *currentPlaceVC;
    NSMutableArray *annotations;
}

@end

@implementation SHTourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapView];
}

- (void)setupPageView {
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SHPageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    SHPlaceViewController *startingViewController = placeViewControllers[0];
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, self.view.frame.size.height + 10, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - 60);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.pageViewController.view.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - 60);
    } completion:nil];
    
    UISwipeGestureRecognizer *pageSwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shrinkCurrentPage:)];
    UISwipeGestureRecognizer *pageSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(expandCurrentPage:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandCurrentPage:)];
    tapGesture.delegate = self;
    pageSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    pageSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.pageViewController.view addGestureRecognizer:pageSwipeDown];
    [self.pageViewController.view addGestureRecognizer:pageSwipeUp];
    [self.pageViewController.view addGestureRecognizer:tapGesture];
}

- (void)setupMapView {
    self.mapView.mapType = MKMapTypeHybrid;
    self.mapView.showsUserLocation = YES;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mapView.delegate = self;
    float spanX = 0.0160;
    float spanY = 0.0160;
    MKCoordinateRegion region;
    region.center.latitude = 37.254017;// self.locationManager.location.coordinate.latitude;
    region.center.longitude = -122.033921;// self.locationManager.location.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
    
    
    MKMapPoint userPoint = MKMapPointForCoordinate(self.mapView.userLocation.location.coordinate);
    MKMapRect mapRect = self.mapView.visibleMapRect;
    BOOL inside = MKMapRectContainsPoint(mapRect, userPoint);
    if(inside) {
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    }
    double zoom = log2(360 * ((self.mapView.frame.size.width/256) / self.mapView.region.span.longitudeDelta));
    NSLog(@"zoom: %f",zoom);
}

- (NSArray *)annotations {
    for(SHPlace *place in places) {
        int index = place.index;
        
        place.annotationThumbnail.expandBlock = ^{
            [self flipToPage:index];
        };
        [annotations addObject:[JPSThumbnailAnnotation annotationWithThumbnail:place.annotationThumbnail]];
        if(annotations.count == places.count) {
            return annotations;
        }
    }
    return nil;
}

- (void)expandCurrentPage: (id)sender {
    currentPlaceVC.expanded = YES;
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.pageViewController.view.frame = CGRectMake(0, 63, self.view.frame.size.width, self.pageViewController.view.frame.size.height);
    } completion:nil];
}

-(void)tapExpandCurrentPage: (id)sender {
    currentPlaceVC.expanded = YES;
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.pageViewController.view.frame = CGRectMake(0, 63, self.view.frame.size.width, self.pageViewController.view.frame.size.height);
    } completion:nil];
    
    UIView *temp = (UIView *)[sender view];
    [temp removeGestureRecognizer: sender];
}

- (void)shrinkCurrentPage: (id)sender {
    currentPlaceVC.expanded = NO;
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.pageViewController.view.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - 60);
    } completion:nil];
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandCurrentPage:)];
    //    tapGesture.delegate = self;
    //    UIView *temp = (UIView *)[sender view];
    //    [temp addGestureRecognizer: tapGesture];
}

- (void)flipToPage:(int)index {
    NSArray *viewControllers  = [NSArray arrayWithObjects:placeViewControllers[index], nil];
    
    if(index > [placeViewControllers indexOfObject:currentPlaceVC]) {
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    } else {
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:NULL];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SHPlaceViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return placeViewControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SHPlaceViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [places count]) {
        return nil;
    }
    return placeViewControllers[index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    if(completed) {
        //pause the old player
        [currentPlaceVC pause];
        JPSThumbnailAnnotation *prevAnnotation = [annotations objectAtIndex:currentPlaceVC.pageIndex];
        [prevAnnotation deselectAnnotationInMap:self.mapView];
        currentPlaceVC = [pageViewController.viewControllers lastObject];
        JPSThumbnailAnnotation *newAnnotation = [annotations objectAtIndex:currentPlaceVC.pageIndex];
        [newAnnotation selectAnnotationInMap:self.mapView];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView placeView:(SHPlaceViewController *)placeVC{
    if((scrollView.contentOffset.y < -30) && placeVC.expanded) {
        [self shrinkCurrentPage:self];
    } else if ((scrollView.contentOffset.y > 100) && !placeVC.expanded) {
        [self expandCurrentPage:self];
    }
}

-(void)enableUserInteraction{
    [self.view setUserInteractionEnabled:YES];
}

- (IBAction)resetMapRegion:(id)sender {
    float spanX = 0.0150;
    float spanY = 0.0150;
    MKCoordinateRegion region;
    region.center.latitude = 37.254017;// self.locationManager.location.coordinate.latitude;
    region.center.longitude = -122.033921;// self.locationManager.location.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
