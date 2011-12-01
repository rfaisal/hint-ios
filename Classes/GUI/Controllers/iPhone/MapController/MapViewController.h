//
//  MapViewController.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "SubscribedViewController.h"

@class AnnotationViewDataSource;
@class PinDetailedViewController;
@class PrivateChatViewController;

@interface MapViewController : SubscribedViewController {
    MKMapView *mapView;
    AnnotationViewDataSource *annotationDataSource;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet AnnotationViewDataSource *annotationDataSource;
@property (nonatomic, retain) IBOutlet PinDetailedViewController* pinDetailedController;
@property (retain, nonatomic) IBOutlet PrivateChatViewController *privateChatController;

-(void)openAnnotationDetails:(id) object;
- (void)subscribe;
- (void)unsubscribe;
//-(void) setPinForLocation: (CLLocation*)location;
//
//-(void) loadAnnotation;

@end
