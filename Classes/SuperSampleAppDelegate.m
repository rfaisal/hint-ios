//
//  SuperSampleAppDelegate.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/22/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "SuperSampleAppDelegate.h"

//Data
#import "StorageProvider.h"
#import "UsersProvider.h"
#import "Users.h"

//Helpers
#import "SSLocationDataSource.h"

//UI
#import "LoginOrRegistrationViewController.h"

//Service
#import "XMPPService.h"

@interface SuperSampleAppDelegate(/*Private*/)

- (void) mergeChanges:(NSNotification *)notification;
- (void) processGeoDatAsync:(NSArray*)geodatas;
- (void) searchGeoData:(NSTimer*)timer;
- (void) setupSearchGeoDataTimer;

@end

@implementation SuperSampleAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize loginOrRegisterController = _loginOrRegisterController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [SSLocationDataSource sharedDataSource];            // initialization of SSLocationDataSource    
    
    // QB settings
	[QBSettings setLogLevel:QBLogLevelDebug];
	[QBSettings setServerDomainTemplate:[NSString stringWithFormat:@"%@%@", @"%@.", endpoint]];	
    
    [QBGeoposService setDomain:@"location.quickblox.com"];
	[QBGeoposService AuthorizeAppId:appID key:appKey secret:appSecret];	
	[QBGeoposService setServiceZone:ServiceZoneProduction];

	[QBUsersService AuthorizeAppId:appID key:appKey secret:appSecret];
    [QBUsersService setServiceZone:ServiceZoneProduction];
		
	[QBBlobsService AuthorizeAppId:appID key:appKey secret:appSecret];	
	[QBBlobsService setServiceZone:ServiceZoneProduction];
	
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [self.viewController presentModalViewController:self.loginOrRegisterController animated:NO];
    
    
    //[self searchGeoData:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark ActionStatusDelegate

- (void)completedWithResult:(Result*)result
{
	if(result.success)
	{
		if([result isKindOfClass:[QBGeoDataSearchResult class]])
		{
			QBGeoDataSearchResult *geoDataSearchRes = (QBGeoDataSearchResult*)result;
			[self performSelectorInBackground:@selector(processGeoDatAsync:) withObject:geoDataSearchRes.geodatas];
		}
	}
	else 
	{
		[self setupSearchGeoDataTimer];
	}
}


#pragma mark -
#pragma mark Private

- (void) searchGeoData:(NSTimer*) timer{
	QBGeoDataSearchRequest *searchRequest = [[QBGeoDataSearchRequest alloc] init];
    searchRequest.radius = 1000;
	//searchRequest.last_only = YES;
	[QBGeoposService findGeoData:searchRequest delegate:self];
	[searchRequest release];
}

-(void)setupSearchGeoDataTimer;{
	[NSTimer scheduledTimerWithTimeInterval:1
									 target:self
								   selector:@selector(searchGeoData:)
								   userInfo:nil
									repeats:NO];
}

-(void) processGeoDatAsync:(NSArray*)geodatas{
    
	NSManagedObjectContext * context = [StorageProvider threadSafeContext];
	NSError *error = nil;
	BOOL hasChanges = NO;
	for (QBGeoData *geoData in geodatas) {
		CLLocation *location = [[CLLocation alloc] initWithLatitude:geoData.latitude longitude:geoData.longitude];

		hasChanges |= [[UsersProvider sharedProvider] updateOrCreateUser:[NSNumber numberWithInt:geoData.user.ID]																			location:location  
																 context:context
																   error:&error];	
        NSLog(@"geo data user: %@", geoData.user);
        NSLog(@"geo data user name: %@", geoData.user.name);
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
	
	[self performSelectorOnMainThread:@selector(setupSearchGeoDataTimer) withObject:nil waitUntilDone:NO];
}

- (void)mergeChanges:(NSNotification *)notification{	
	NSManagedObjectContext * sharedContext = [StorageProvider sharedInstance].managedObjectContext;
	NSManagedObjectContext * currentContext = (NSManagedObjectContext *)[notification object];
	if ( currentContext == sharedContext) {		
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

- (void) signIn{
    Users *user = [[UsersProvider sharedProvider] currentUser];
    if(user == nil){
        [[[[UIAlertView alloc] initWithTitle:@"" 
                                     message:NSLocalizedString(@"Please, login at first", @"login at first") 
                                    delegate:nil 
                           cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
                           otherButtonTitles:nil] autorelease] show];
        return;
    }
    
    /*
    if (![[SSLocationDataSource sharedDataSource] isLocationValid])
    {
        [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location absent.", @"Location absent") 
                                     message:NSLocalizedString(@"Please, wait until location will be updated", @"Wrong location") 
                                    delegate:nil 
                           cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
                           otherButtonTitles:nil] autorelease] show];
        
        return ;
    }*/
    
    [self.viewController dismissModalViewControllerAnimated:YES];
}

- (IBAction) logout{
    [QBUsersService logoutUser:nil];
    
    [self.viewController presentModalViewController:self.loginOrRegisterController animated:YES];
}

- (void)dealloc{
    [_window release];
    [_viewController release];
    [_loginOrRegisterController release];
	[super dealloc];
}

@end