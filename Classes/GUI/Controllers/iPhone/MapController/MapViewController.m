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
#import "SourceImagesProvider.h"

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
	updateGeoDataTimer = [NSTimer scheduledTimerWithTimeInterval:kUpdateMapInterval
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
        
        // save user
		CLLocation *location = [[CLLocation alloc] initWithLatitude:geoData.latitude longitude:geoData.longitude];
		hasChanges |= [[UsersProvider sharedProvider] updateOrCreateUser:geoData.user                                                                                      
                                                                location:location  
                                                                  status:geoData.status
                                                                 context:context
																   error:&error];	
		[location release];
        
        // if user has avatar
        if(geoData.user.externalUserID){ // temporary fix. Use 'blob_id' instead 'externalUserID'
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
}

- (void) getAvatarAndStoreForQBUserAsync:(QBUUser *)qbUser{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSManagedObjectContext *context = [StorageProvider threadSafeContext];
    NSError *error;
    
    // already exist
    // temporary fix. Use 'blob_id' instead 'externalUserID'
    if([[SourceImagesProvider sharedProvider] imageByUID:qbUser.externalUserID error:nil context:context]){
        [pool drain];
        return;
    }
    
    // get blob
    QBBlobResult *blobResul = [QBBlobsService GetBlobInfo:qbUser.externalUserID];
    if(!blobResul.success){
        [self performSelectorOnMainThread:@selector(processErrors:) withObject:blobResul.answer.errors waitUntilDone:YES];
        [pool drain];
        return;
    }
    
    QBBlob *blob = blobResul.blob;
    
    
    // get file
    QBBlobFileResult *blobFileResult = [QBBlobsService GetBlob:blob.UID];
    if(!blobFileResult.success){
        [self performSelectorOnMainThread:@selector(processErrors:) withObject:blobResul.answer.errors waitUntilDone:YES];
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

-(void) releaseProperties{
    mapView = nil;
    annotationDataSource = nil;
    pinDetailedController = nil;
    
    [super releaseProperties];
}

-(void)showMessage:(NSString*)title message:(NSString*)msg{
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:msg 
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"OK", "") 
										  otherButtonTitles:nil];
	
	alert.tag = (title == NSLocalizedString(@"Registration successful", "") ? 1 : 0);
	[alert show];
	[alert release];	
}

-(void)processErrors:(NSMutableArray*)errors{
	NSMutableString *errorsString = [NSMutableString stringWithCapacity:0];
	
	for(NSString *error in errors){
		[errorsString appendFormat:@"%@\n", error];
	}
	
	if ([errorsString length] > 0) {
		[self showMessage:NSLocalizedString(@"Error", "") message:errorsString];
	}
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
        // Search GeoData
		if([result isKindOfClass:[QBGeoDataSearchResult class]]){
			QBGeoDataSearchResult *geoDataSearchRes = (QBGeoDataSearchResult *)result;
			[self performSelectorInBackground:@selector(processGeoDatAsync:) withObject:geoDataSearchRes.geodatas];
		}
        
        // Get Blob Info
        else if([result isKindOfClass:[QBBlobResult class]]){
            QBBlobResult *res = (QBBlobResult *)result;
            NSString *blobUID = res.blob.UID;
            [QBBlobsService GetBlobAsync:blobUID delegate:self];
        
        // Get Blob File
        }else if([result isKindOfClass:[QBBlobFileResult class]]){
            QBBlobFileResult* res = (QBBlobFileResult*)result;
            NSData *avatarData = res.data;
            if(avatarData){
                    
            }						
        }

    // errors
	}else{
        [self processErrors:result.answer.errors];
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