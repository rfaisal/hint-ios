//
//  MapViewController.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SubscribedViewController.h"

@class AnnotationViewDataSource;
@class PinDetailedViewController;

@interface MapViewController : SubscribedViewController <ActionStatusDelegate> {
    MKMapView *mapView;
    AnnotationViewDataSource *annotationDataSource;
    
    NSTimer *updateGeoDataTimer;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet AnnotationViewDataSource *annotationDataSource;
@property (nonatomic, retain) IBOutlet PinDetailedViewController *pinDetailedController;

- (void) openAnnotationDetails:(id) object;

- (void) startRetrieveNewPoints;
- (void) retrievePoints:(NSTimer *) timer;

- (void) getAvatarAndStoreForQBUserAsync:(QBUUser *)user;

@end