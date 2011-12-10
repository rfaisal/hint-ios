//
//  ChatViewController.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "ChatViewController.h"

//Data
#import "Messages.h"
#import "UsersProvider.h"
#import "ChatListProvider.h"
#import "StorageProvider.h"
#import "Users.h"


@implementation ChatViewController
@synthesize chatDataSource;
@synthesize tabView;
@synthesize textField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)subscribe{
    [super subscribe];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refreshChat:) 
                                                 name:nRefreshChat object:nil];
}

-(void)unsubscribe{
    [super unsubscribe];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nRefreshChat object:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [chatDataSource reloadData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.tabView addGestureRecognizer:tap];
    
    // progress wheel
    wheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    wheel.center =  CGPointMake(textField.frame.size.width - 16, textField.center.y-7);
    [textField addSubview:wheel];
    [wheel release];
}

- (void)viewDidUnload{
    [self setTextField:nil];
    [self setChatDataSource:nil];
    [self setTabView:nil];
    
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self searchGeoData:nil];
    [self startSearchGeoData];
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [updateGeoDataTimer invalidate];
    updateGeoDataTimer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark
#pragma mark GeoData
#pragma mark

- (void) searchGeoData:(NSTimer *) timer{
	QBGeoDataSearchRequest *searchRequest = [[QBGeoDataSearchRequest alloc] init];
	searchRequest.status = YES;
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


#pragma mark
#pragma mark IBActions
#pragma mark

-(IBAction) sendAction:(id)sender{
    
    if ([textField.text isEqualToString:@""]) {
        return;
    }    
    
    Users *user = [[UsersProvider sharedProvider] currentUser];

	QBGeoData *geoData = [QBGeoData currentGeoData];
	geoData.user = user.mbUser;
    geoData.appID = appID;
    geoData.status = textField.text;

    // post geodata
	[QBGeoposService postGeoData:geoData delegate:self];	
    
    [wheel startAnimating];
}

-(void) processGeoDatumAsync:(QBGeoData *)data {	
	CLLocation *location =  [[QBLocationDataSource instance] currentLocation];
		
	NSManagedObjectContext *context = [StorageProvider threadSafeContext];
	NSError *error = nil;
	BOOL hasChanges = NO;
	
	NSString *msg = [NSString stringWithFormat:@"%@", data.status];	
	NSString *Id = [NSString stringWithFormat:@"%f", data.ID];
	Messages *message = [[ChatListProvider sharedProvider] addMessageWithUID:Id 
																	   text:msg 
																   location:[NSString stringWithFormat:@"%@", location] 
                                                                       user:[[UsersProvider sharedProvider] currentUser]
																	context:context];

		
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
	hasChanges &= [context save:&error];
	[nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
	if(hasChanges){
		[nc postNotificationName:nRefreshChat object:nil userInfo:nil];			
	}
}

-(void) processGeoDataAsync:(NSArray *)geodata{
    
	NSManagedObjectContext *context = [StorageProvider threadSafeContext];
	NSError *error = nil;
	
    BOOL hasChanges = NO;
    
	for (QBGeoData *geoData in geodata) {
        
        // message already exist
        if([[ChatListProvider sharedProvider] messageByUID:[NSNumber numberWithUnsignedInteger:geoData.ID]]){
            continue;
        }
        
        Users *user = [[UsersProvider sharedProvider] userByUID:[NSNumber numberWithUnsignedInteger:geoData.user.ID]];
        if(user == nil){
            // create user
            CLLocation *location = [[CLLocation alloc] initWithLatitude:geoData.latitude longitude:geoData.longitude];
        
            [[UsersProvider sharedProvider] updateOrCreateUser:geoData.user                                                                                      
                                                      location:location  
                                                        status:geoData.status
                                                       context:context
                                                         error:&error];	
            [location release];
        }
        
        NSString *msg = [NSString stringWithFormat:@"%@", geoData.status];	
        NSString *Id = [NSString stringWithFormat:@"%f", geoData.ID];
        Messages *message = [[ChatListProvider sharedProvider] addMessageWithUID:Id 
                                                                            text:msg 
                                                                        location:[NSString stringWithFormat:@"%@", [geoData location]] 
                                                                            user:user];
        hasChanges = YES;
	}
	
	if(hasChanges){
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
		[nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
        
		hasChanges = [context save:&error];
		
        [nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
        
		if(hasChanges){
			[nc postNotificationName:nRefreshChat object:nil userInfo:nil];			
		}	
	}
}

- (void)mergeChanges:(NSNotification *)notification{	
	NSManagedObjectContext * sharedContext = [StorageProvider sharedInstance].managedObjectContext;
	NSManagedObjectContext * currentContext = (NSManagedObjectContext *)[notification object];
	if(currentContext == sharedContext){		
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


#pragma mark
#pragma mark Notifications
#pragma mark

// refresh Chat
-(void)refreshChat:(NSNotification *)notification{
	[chatDataSource performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}


#pragma mark
#pragma mark ActionStatusDelegate
#pragma mark

- (void)completedWithResult:(Result*)result{
    // create
    if([result isKindOfClass:[QBGeoDataResult class]]){
        if(result.success){
            QBGeoDataResult *geoDataRes = (QBGeoDataResult*)result; 
            [self performSelectorInBackground:@selector(processGeoDatumAsync:) withObject:geoDataRes.geoData];
        }
        [wheel stopAnimating];
        
    // search a new one
    }else if([result isKindOfClass:[QBGeoDataSearchResult class]]){
        if(result.success){
            QBGeoDataSearchResult *geoDataSearchRes = (QBGeoDataSearchResult *)result;
            [self performSelectorInBackground:@selector(processGeoDataAsync:) withObject:geoDataSearchRes.geodatas];
        }
    }
}


#pragma mark -

-(void)dismissKeyboard {
    [textField resignFirstResponder];
}

-(void) dealloc{
    [chatDataSource release];
    [textField release];
    [tabView release];
    [super dealloc];
}

@end