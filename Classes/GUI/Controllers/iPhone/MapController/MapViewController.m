//
//  MapViewController.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "MapViewController.h"

//Data source
#import "SSLocationDataSource.h"
#import "AnnotationViewDataSource.h"

//Controllers
#import "PinDetailedViewController.h"
#import "PrivateChatViewController.h"

@implementation MapViewController
@synthesize mapView;
@synthesize annotationDataSource;
@synthesize pinDetailedController;
@synthesize privateChatController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    [annotationDataSource reloadData];
    

//	MKCoordinateRegion region;    
//    MKCoordinateSpan span;
//	span.latitudeDelta = 50.65;
//	span.longitudeDelta = 50.65;
//	region.span = span;

//    [[LocationDataSource instance] addObserver:self forKeyPath: @"currentLocation" options:NSKeyValueObservingOptionPrior context:nil];
//    CLLocation* location= [[SSLocationDataSource sharedDataSource] getCurrentLocation];
//	region.center = location.coordinate;

//    [mapView setRegion: region animated: YES];
//    [self setPinForLocation:location];

//    [self loadAnnotation];

}

- (void)subscribe 
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openAnnotationDetails:) name:nOpenAnnotationDetails object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAnnotationDetails:) name:nRefreshAnnotationDetails object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openChatView:) name:nOpenChatView object:nil];
}

- (void)unsubscribe 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nOpenAnnotationDetails object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nRefreshAnnotationDetails object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nOpenChatView object:nil];
}

-(void)openAnnotationDetails:(NSNotification*)notification{
    if ([[notification userInfo] objectForKey:nkData]) {
        [self presentCustomModalViewController:self.pinDetailedController animated:YES];
        self.pinDetailedController.objectID = [[notification userInfo] objectForKey:nkData];
    }
}

-(void)refreshAnnotationDetails:(NSNotification*)notification
{
	[annotationDataSource reloadData];
}

-(void)openChatView:(NSNotification*)notification
{
    [self.navigationController pushViewController:self.privateChatController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void) releaseProperties{
    mapView=nil;
    annotationDataSource=nil;
    pinDetailedController=nil;
    [super releaseProperties];
}
- (void)dealloc {
    [privateChatController release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPrivateChatController:nil];
    [super viewDidUnload];
}
@end
