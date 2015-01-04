//
//  JPSThumbnailAnnotation.h
//  JPSThumbnailAnnotationView
//
//  Created by Jean-Pierre Simard on 4/21/13.
//  Copyright (c) 2013 JP Simard. All rights reserved.
//

@import Foundation;
@import MapKit;
#import "JPSThumbnail.h"
#import "JPSThumbnailAnnotationView.h"

@protocol JPSThumbnailAnnotationProtocol <NSObject>

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView;

@end

@interface JPSThumbnailAnnotation : NSObject <MKAnnotation, JPSThumbnailAnnotationProtocol>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readwrite) JPSThumbnailAnnotationView *view;
@property (nonatomic, readonly) JPSThumbnail *thumbnail;

+ (instancetype)annotationWithThumbnail:(JPSThumbnail *)thumbnail;
- (id)initWithThumbnail:(JPSThumbnail *)thumbnail;
- (void)updateThumbnail:(JPSThumbnail *)thumbnail animated:(BOOL)animated;

- (void)selectAnnotationInMap:(MKMapView *)mapview;
- (void)deselectAnnotationInMap:(MKMapView *)mapview;

@end
