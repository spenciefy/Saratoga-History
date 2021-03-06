//
//  SHBaseViewController.m
//  Saratoga History
//
//  Created by Spencer Yen on 12/19/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

@import MapKit;

#import "SHBaseViewController.h"
#import <JPSThumbnailAnnotation/JPSThumbnailAnnotation.h>
#import <Parse/Parse.h>
@interface SHBaseViewController ()

@property (nonatomic, strong) UIView *mainView;

@end

@implementation SHBaseViewController {
    NSArray *places;
    NSMutableArray *placeViewControllers;
    SHPlaceViewController *currentPlaceVC;
    NSMutableArray *annotations;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapView];
    
    [self loadPlaceViewControllersWithCompletion:^(NSArray *placeVCs, NSError *error) {
        placeViewControllers = [placeVCs mutableCopy];
        [self setupPageView];
        annotations = [[NSMutableArray alloc] init];
        annotations = [[self annotations] mutableCopy];
        [self.mapView addAnnotations:annotations];
        
#warning hacky lol
        int64_t delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            JPSThumbnailAnnotation *annotation = [annotations objectAtIndex:0];
            if(annotation.view) {
                [annotation selectAnnotationInMap:self.mapView];
            } else {
                int64_t delayInSeconds = 0.3;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [annotation selectAnnotationInMap:self.mapView];

                });
            }
        });
    }];
    
//    NSArray *images = @[UIImageJPEGRepresentation([UIImage imageNamed:@"SaratogaHistory2.jpg"], 1.0), UIImageJPEGRepresentation([UIImage imageNamed:@"SaratogaHistoryImage.jpg"], 1.0)];
//    NSArray *captions = @[@"history museum so cool", @"wasai so pro"];
//    NSData *imagesData = [NSKeyedArchiver archivedDataWithRootObject:images];
//    
//    PFFile *imageFile = [PFFile fileWithData:imagesData];
//    
//    [[SHPlaceManager sharedInstance] uploadPhotos:imageFile withCaptions:captions toObjectID:@"EH2qAPIoba"];
//    [[SHPlaceManager sharedInstance] uploadPhotos:imageFile withCaptions:captions toObjectID:@"58HmKB5Ow6"];
//    [[SHPlaceManager sharedInstance] uploadPhotos:imageFile withCaptions:captions toObjectID:@"1DcZ8K3xpr"];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPlaceViewControllersWithCompletion:(void (^)(NSArray *placeVCs, NSError *error))completionBlock {
    [[SHPlaceManager sharedInstance] placesWithCompletion:^(NSArray *placesArray, NSError *error) {
        places = placesArray;
        NSMutableArray *placeVCs = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < places.count; i++) {
            SHPlaceViewController *placeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SHPlaceViewController"];
            placeViewController.pageIndex = i;
            placeViewController.place = places[i];
            placeViewController.delegate = self;
            placeViewController.expanded = NO;
            placeViewController.showsAudioView = YES;

            [placeVCs addObject:placeViewController];
            
            if(i == places.count - 1) {
                completionBlock(placeVCs, nil);
            }
        }
    }];
}

- (void)setupPageView {
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SHPageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    SHPlaceViewController *startingViewController = placeViewControllers[0];
    currentPlaceVC = startingViewController;

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

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
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

- (IBAction)segmentedControlAction:(id)sender {
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        //nothing
    } else if(self.segmentedControl.selectedSegmentIndex == 1) {
        [self performSegueWithIdentifier:@"ModalTourVC" sender:self];
    } else {
        //something for more
    }
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
