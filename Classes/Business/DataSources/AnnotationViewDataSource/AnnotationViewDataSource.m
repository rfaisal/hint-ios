//
//   AnnotationViewDataSource.m
//  SuperSample
//
//  Created by Danil on 20.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "AnnotationViewDataSource.h"

//UI
#import "MapPinView.h"
#import "MapPinAnnotation.h"

//Data
#import "Users.h"
#import "UsersProvider.h"

@implementation AnnotationViewDataSource
@synthesize mapView, ownAnnotation;

#pragma mark - 
#pragma mark MKMapDelegate

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation{

    static NSString *annotationReuseIdentifier = @"UserAnnotationIdentifier";
    
	MapPinAnnotation *mapPinAnnotation = (MapPinAnnotation *) annotation;
    
    MapPinView *pin = (MapPinView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:annotationReuseIdentifier];
    if(pin == nil){
        pin = [[[MapPinView alloc]  initWithAnnotation:annotation 
                                        reuseIdentifier:annotationReuseIdentifier] autorelease];
    }
	pin.annotationModel = mapPinAnnotation;
    
    [pin updateStatusWithAnimation:YES];
    
    
    // save own annotation
    if(NSClassFromString(@"MKUserLocation") == [annotation class]){
        self.ownAnnotation = annotation;
    }
    
	return pin;
}

-(void) reloadData{

    NSArray *oldAnnotation = [NSArray arrayWithArray:[mapView.annotations 
                                                      filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"!(self isKindOfClass: %@)", 
                                                                                   [MKUserLocation class]]]];
    // add new annotations
    NSArray *usersArray = [[UsersProvider sharedProvider] getAllUsersWithError:nil withOwn:NO];
    
	CLLocationCoordinate2D coordinate;
	for (NSManagedObject *model in usersArray) {
        Users *user = (Users *)model; 	
        coordinate.latitude = [user.latitude doubleValue];
        coordinate.longitude = [user.longitude doubleValue];
        MapPinAnnotation *newMapPinAnnotation = [[MapPinAnnotation alloc] initWithCoordinate:coordinate];
        newMapPinAnnotation.userModel = user;
        [mapView addAnnotation:newMapPinAnnotation];
		[newMapPinAnnotation release];
    }	
    
    // remove all annotations without own
    [mapView performSelector:@selector(removeAnnotations:) withObject:oldAnnotation afterDelay:0.1];
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
}

- (void)dealloc {
    [mapView release];
    self.ownAnnotation = nil;
    
    [super dealloc];
}

@end