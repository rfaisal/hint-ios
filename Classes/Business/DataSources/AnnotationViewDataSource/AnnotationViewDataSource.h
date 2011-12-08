//
//   AnnotationViewDataSource.h
//  SuperSample
//
//  Created by Danil on 20.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "LoadableDataSource.h"

@interface AnnotationViewDataSource : LoadableDataSource <MKMapViewDelegate> {
    
    MKMapView *mapView;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

-(void) reloadData;

@end