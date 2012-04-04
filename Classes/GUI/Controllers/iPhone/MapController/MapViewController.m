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
	QBLGeoDataSearchRequest *searchRequest = [[QBLGeoDataSearchRequest alloc] init];
	searchRequest.last_only = YES; // only last location
    searchRequest.perPage = 15; // last 15 points
    
    // retrieve geodata
	[QBLocationService findGeoData:searchRequest delegate:self];
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
            [self performSelectorInBackground:@selector(getAvatarAndStoreForQBUserAsync:) withObject:geoData.user];
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

// Retrieve user avatar
- (void) getAvatarAndStoreForQBUserAsync:(QBUUser *)qbUser{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSManagedObjectContext *context = [StorageProvider threadSafeContext];
    NSError *error;
    
    // already exist
    if([[SourceImagesProvider sharedProvider] imageByUID:qbUser.blobID error:nil context:context]){
        [pool drain];
        return;
    }
    
    // get blob
    QBBlobResult *blobResul = [QBBlobsService GetBlobInfo:qbUser.blobID];
    if(!blobResul.success){
        NSLog(@"blobResul.errors=%@", blobResul.errors);
        [pool drain];
        return;
    }
    
    QBBlob *blob = blobResul.blob;
    

    // get file
    QBBlobFileResult *blobFileResult = [QBBlobsService GetBlob:blob.UID];
    if(!blobFileResult.success){
        NSLog(@"blobResul.errors=%@", blobResul.errors);
        [pool drain];
        return;
    }
    
    // save image
    SourceImages *sourceImage = [[SourceImagesProvider sharedProvider] addImage:[UIImage imageWithData:blobFileResult.data]
                                                                        withUID:blob.ID 
                                                                      globalURL:blob.UID 
                                                                       localURL:nil 
                                                                        context:context];
    
	if(sourceImage){
        // update user
        Users *user = [[UsersProvider sharedProvider] userByUID:[NSNumber numberWithUnsignedInt:qbUser.ID] context:context];
		user.photo = sourceImage;
		
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
		[nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
		[context save:&error];
		[nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];	
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
#pragma mark ActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result *)result{
    
    // Result success
	if(result.success){
        
        // Retrieve points result
		if([result isKindOfClass:[QBLGeoDataPagedResult class]]){
			QBLGeoDataPagedResult *geoDataSearchRes = (QBLGeoDataPagedResult *)result;
			[self performSelectorInBackground:@selector(processPoints:) withObject:geoDataSearchRes.geodatas];
		}
        
        // Get Blob Info result
        else if([result isKindOfClass:[QBBlobResult class]]){
            QBBlobResult *res = (QBBlobResult *)result;
            NSString *blobUID = res.blob.UID;
            [QBBlobsService GetBlobAsync:blobUID delegate:self];
        
        // Get Blob File result
        }else if([result isKindOfClass:[QBBlobFileResult class]]){
					
        }
	}
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)dealloc {
    [super dealloc];
}

@end