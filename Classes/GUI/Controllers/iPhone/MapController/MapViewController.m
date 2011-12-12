//
//  MapViewController.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "MapViewController.h"

//Data source
#import "AnnotationViewDataSource.h"

//Controllers
#import "PinDetailedViewController.h"
#import "PrivateChatViewController.h"

// Data
#import "StorageProvider.h"
#import "UsersProvider.h"

#import "Users.h"
#import "MapPinView.h"

@implementation MapViewController
@synthesize mapView;
@synthesize annotationDataSource;
@synthesize pinDetailedController;
@synthesize privateChatController;


#pragma mark
#pragma mark Init
#pragma mark

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark
#pragma mark Controller's life
#pragma mark

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self searchGeoData:nil];
    [self startSearchGeoData];
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [updateGeoDataTimer invalidate];
    updateGeoDataTimer = nil;
}

- (void)viewDidUnload {
    [self setPrivateChatController:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark
#pragma mark GeoData
#pragma mark

- (void) searchGeoData:(NSTimer *) timer{
	QBGeoDataSearchRequest *searchRequest = [[QBGeoDataSearchRequest alloc] init];
	searchRequest.last_only = YES;
    searchRequest.userAppID = appID;
	[QBGeoposService findGeoData:searchRequest delegate:self];
	[searchRequest release];
}

-(void) startSearchGeoData{
	updateGeoDataTimer = [NSTimer scheduledTimerWithTimeInterval:kGeoposServiceGetGeoDatInterval
                                                          target:self
                                                        selector:@selector(searchGeoData:)
                                                        userInfo:nil
                                                         repeats:YES];
}

-(void) processGeoDatAsync:(NSArray *)geodatas{
    
	NSManagedObjectContext *context = [StorageProvider threadSafeContext];
	NSError *error = nil;
	
    BOOL hasChanges = NO;

	for (QBGeoData *geoData in geodatas) {
        
        // skip own
        if(geoData.user.ID == [[UsersProvider sharedProvider] currentUserID]){
            [[UsersProvider sharedProvider] currentUser].status = geoData.status;
            
            continue;
        }
        
		CLLocation *location = [[CLLocation alloc] initWithLatitude:geoData.latitude longitude:geoData.longitude];
        
		hasChanges |= [[UsersProvider sharedProvider] updateOrCreateUser:geoData.user                                                                                      
                                                                location:location  
                                                                  status:geoData.status
                                                                 context:context
																   error:&error];	
		[location release];
	}
	
	if(hasChanges){
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
		[nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
        
		hasChanges = [context save:&error];
		
        [nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
        
		if(hasChanges){
			[nc postNotificationName:nRefreshAnnotationDetails object:nil userInfo:nil];			
		}		
	}
}

- (void) mergeChanges:(NSNotification *)notification{	
	NSManagedObjectContext *sharedContext = [StorageProvider sharedInstance].managedObjectContext;
	NSManagedObjectContext *currentContext = (NSManagedObjectContext *)[notification object];
	if (currentContext == sharedContext) {		
		[currentContext performSelector:@selector(mergeChangesFromContextDidSaveNotification:) 
							   onThread:[NSThread currentThread] 
							 withObject:notification 
						  waitUntilDone:NO];		
	}else {
		[sharedContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
										withObject:notification 
									 waitUntilDone:YES];	
	}
}

- (void)subscribe {
    [super subscribe];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(openAnnotationDetails:) 
                                                 name:nOpenAnnotationDetails object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refreshAnnotationDetails:) 
                                                 name:nRefreshAnnotationDetails object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(openPrivateChatView:) 
                                                 name:nOpenPrivateChatView object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(ownStatusDidChange:) 
                                                 name:nChangedOwnStatus object:nil];
    
    
}

- (void)unsubscribe {
    [super unsubscribe];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nOpenAnnotationDetails object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nRefreshAnnotationDetails object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nOpenPrivateChatView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nChangedOwnStatus object:nil];
}

-(void) releaseProperties{
    mapView = nil;
    annotationDataSource = nil;
    pinDetailedController = nil;
    
    [super releaseProperties];
}


#pragma mark
#pragma mark Notifications
#pragma mark

// Show Users's info
-(void)openAnnotationDetails:(NSNotification *)notification{
    if ([[notification userInfo] objectForKey:nkData]) {
        [self presentCustomModalViewController:self.pinDetailedController animated:YES];
        self.pinDetailedController.objectID = [[notification userInfo] objectForKey:nkData];
    }
}

// refresh annotations on Map
-(void)refreshAnnotationDetails:(NSNotification *)notification{
	[annotationDataSource performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

-(void)openPrivateChatView:(NSNotification *)notification{
    [self.navigationController pushViewController:self.privateChatController animated:YES];
}

-(void)ownStatusDidChange:(NSNotification *)notification{
    MapPinView *ownPinView = (MapPinView *)[mapView viewForAnnotation:annotationDataSource.ownAnnotation];
    [ownPinView updateStatusWithAnimation:NO];
}


#pragma mark
#pragma mark ActionStatusDelegate
#pragma mark

- (void)completedWithResult:(Result *)result{
	if(result.success){
		if([result isKindOfClass:[QBGeoDataSearchResult class]]){
			QBGeoDataSearchResult *geoDataSearchRes = (QBGeoDataSearchResult *)result;
			[self performSelectorInBackground:@selector(processGeoDatAsync:) withObject:geoDataSearchRes.geodatas];
		}
	}
}


#pragma mark
#pragma mark Dealloc
#pragma mark

- (void)dealloc {
    [privateChatController release];
    
    [super dealloc];
}

@end