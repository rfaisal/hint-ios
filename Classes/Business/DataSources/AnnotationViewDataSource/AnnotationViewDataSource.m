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
	userAnnotation *ua = (userAnnotation *) annotation;
	PinView *pin = [[PinView alloc]  initWithAnnotation:annotation 
                                        reuseIdentifier:@"UserAnnotationIdentifier"
                                              ownMarker:NSClassFromString(@"MKUserLocation") == [annotation class] ? YES : NO];
	pin.annotationModel = ua;
    
	return pin;
}

-(void) reloadData{
    NSArray *usersArray = [[UsersProvider sharedProvider] getAllUsersWithError:nil];

    BOOL needUpdate = NO;
	if([mapView.annotations count] != 0){
		[mapView removeAnnotations:mapView.annotations];
	}
	
	CLLocationCoordinate2D coordinate;
	for (NSManagedObject *model in usersArray) {
        Users *user = (Users *)model; 	
        
        // skip own
        //if(user.mbUser.ID == [[UsersProvider sharedProvider] currentUser].mbUser.ID){
        //    continue;
        //}
        
        coordinate.latitude = [user.latitude doubleValue];
        coordinate.longitude = [user.longitude doubleValue];
        userAnnotation *newAnnotation = [[userAnnotation alloc] initWithCoordinate:coordinate];
        newAnnotation.userModel = user;
        [mapView addAnnotation:newAnnotation];
		[newAnnotation release];
        
		needUpdate = YES;
    }	
	
	if(needUpdate){
		//[mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(1, 1)) animated:YES];
	}
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