//
//  MapViewController.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "MapViewController.h"

//Data source
#import "AnnotationViewDataSource.h"

//Controllers
#import "PinDetailedViewController.h"

// Data
#import "StorageProvider.h"
#import "UsersProvider.h"
#import "SourceImagesProvider.h"

#import "Users.h"
#import "MapPinView.h"


@implementation MapViewController
@synthesize mapView;
@synthesize annotationDataSource;
@synthesize pinDetailedController;


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


#pragma mark -
#pragma mark Controller's life

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad{
    [super viewDidLoad];
    [FlurryAPI logEvent:@"MapViewController, viewDidLoad"];
    
    [annotationDataSource reloadData];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // retrieve points
    [self retrievePoints:nil];
    
    // retrieve points every kUpdateMapInterval seconds
    [self startRetrieveNewPoints];
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [updateGeoDataTimer invalidate];
    updateGeoDataTimer = nil;
}

- (void)viewDidUnload {
    self.mapView = nil;
    self.annotationDataSource = nil;
    self.pinDetailedController = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Retrieve new points
- (void) retrievePoints:(NSTimer *) timer{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // create QBLGeoDataSearchRequest entity
	QBLGeoDataGetRequest *searchRequest = [[QBLGeoDataGetRequest alloc] init];
	searchRequest.lastOnly = YES; // only last location
    searchRequest.perPage = 15; // last 15 points
    
    // retrieve geodata
	[QBLocation geoDataWithRequest:searchRequest delegate:self];
	[searchRequest release];
}

// Retrieve points every kUpdateMapInterval seconds
-(void) startRetrieveNewPoints{
	updateGeoDataTimer = [NSTimer scheduledTimerWithTimeInterval:kUpdateMapInterval
                                                          target:self
                                                        selector:@selector(retrievePoints:)
                                                        userInfo:nil
                                                         repeats:YES];
}

// Process points
-(void) processPoints:(NSArray *)geodatas{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	NSManagedObjectContext *context = [StorageProvider threadSafeContext];
	NSError *error = nil;
    
    BOOL hasChanges = NO;

	for (QBLGeoData *geoData in geodatas) {
        
        // skip own
        if(geoData.user.ID == [[UsersProvider sharedProvider] currentUserID]){
            [[UsersProvider sharedProvider] currentUser].status = geoData.status;
            continue;
        }
        

        // save point
		CLLocation *location = [[CLLocation alloc] initWithLatitude:geoData.latitude longitude:geoData.longitude];
		hasChanges |= [[UsersProvider sharedProvider] updateOrCreateUser:geoData.user                                                                                      
                                                                location:location  
                                                                  status:geoData.status
                                                                 context:context
																   error:&error];
        
		[location release];
        
        // if user has avatar - get it
        if(geoData.user.blobID){
            if(![[SourceImagesProvider sharedProvider] imageByUID:geoData.user.blobID error:nil context:context]){
                [QBContent TDownloadFileWithBlobID:geoData.user.blobID delegate:self context:geoData.user];
            }
        }
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
    
    [pool drain];
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


#pragma mark -
#pragma mark Notifications

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
    // not implemented yet
}

-(void)ownStatusDidChange:(NSNotification *)notification{
    MapPinView *ownPinView = (MapPinView *)[mapView viewForAnnotation:annotationDataSource.ownAnnotation];
    [ownPinView updateStatusWithAnimation:NO];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result *)result{
    
    // Result success
	if(result.success){
        
        // Retrieve points result
		if([result isKindOfClass:[QBLGeoDataPagedResult class]]){
			QBLGeoDataPagedResult *geoDataSearchRes = (QBLGeoDataPagedResult *)result;
			[self performSelectorInBackground:@selector(processPoints:) withObject:geoDataSearchRes.geodata];
		}
	}
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)completedWithResult:(Result *)result context:(void *)contextInfo{
    // Download file result 
    if([result isKindOfClass:[QBCFileDownloadTaskResult class]]){
        if(result.success){
            QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
            
            QBUUser *qbuser = (QBUUser *)contextInfo;
            
            NSManagedObjectContext *context = [StorageProvider threadSafeContext];
            NSError *error;
            
            // save image
            SourceImages *sourceImage = [[SourceImagesProvider sharedProvider] addImage:[UIImage imageWithData:res.file]
                                                                                withUID:qbuser.blobID
                                                                              globalURL:nil
                                                                               localURL:nil 
                                                                                context:context];
            
            if(sourceImage){
                // update user
                Users *user = [[UsersProvider sharedProvider] userByUID:[NSNumber numberWithUnsignedInt:qbuser.ID] context:context];
                user.photo = sourceImage;
                
                NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
                [nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
                [context save:&error];
                [nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];	
            } 

        }
    }
}

- (void)dealloc {
    [super dealloc];
}

@end