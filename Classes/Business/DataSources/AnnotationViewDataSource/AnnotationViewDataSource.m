//
//   AnnotationViewDataSource.m
//  SuperSample
//
//  Created by Danil on 20.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "AnnotationViewDataSource.h"

//UI
#import "PinView.h"
#import "userAnnotation.h"

//Data
#import "Users.h"
#import "UsersProvider.h"

@implementation AnnotationViewDataSource
@synthesize mapView;

#pragma mark - 
#pragma mark MKMapDelegate

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation{

    static NSString *annotationReuseIdentifier = @"UserAnnotationIdentifier";
    
	userAnnotation *ua = (userAnnotation *) annotation;
    
    PinView *pin = (PinView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:annotationReuseIdentifier];
    if(pin == nil){
        pin = [[[PinView alloc]  initWithAnnotation:annotation 
                                        reuseIdentifier:annotationReuseIdentifier] autorelease];
    }
	pin.annotationModel = ua;
    
    [pin updateStatusWithAnimation:YES];
    
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
        userAnnotation *newAnnotation = [[userAnnotation alloc] initWithCoordinate:coordinate];
        newAnnotation.userModel = user;
        [mapView addAnnotation:newAnnotation];
		[newAnnotation release];
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
    
    [super dealloc];
}

@end