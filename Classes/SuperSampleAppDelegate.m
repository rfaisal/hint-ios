//
//  SuperSampleAppDelegate.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/22/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SuperSampleAppDelegate.h"

//Helpers

#import "UsersProvider.h"
#import "Users.h"

//UI
#import "SplashController.h"

@implementation SuperSampleAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize splashController = _splashController;
@synthesize quizRootController = _quizRootController;
@synthesize facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [FlurryAPI startSession:FLURRY_API_KEY];
    
    [QBSettings setServerDomainTemplate:[NSString stringWithFormat:@"%@%@", @"%@.", endpoint]];	
    
    // set log level
    //[QBSettings setLogLevel:QBLogLevelNothing];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [self.viewController presentModalViewController:self.splashController animated:NO];
    
    facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:self];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"didReceiveRemoteNotification userInfo=%@", userInfo);
    [self showMessage:[[userInfo objectForKey:QBMPushMessageApsKey] objectForKey:QBMPushMessageAlertKey] message:nil];
}

- (void)startTrackOwnLocation{
    return;
    [[QBLLocationDataSource instance] setCallbackSelectorForLocationUpdate:@selector(didUpdateToLocation:fromLocation:) forTarget:self];
    [[[QBLLocationDataSource instance] locationManager] startUpdatingLocation];
}

- (void)stopTrackOwnLocation{
    [[QBLLocationDataSource instance] setCallbackSelectorForLocationUpdate:nil forTarget:nil];
    [[[QBLLocationDataSource instance] locationManager] stopUpdatingLocation];
}

- (void)didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"Location didUpdate from %@ to %@", oldLocation, newLocation);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 

    Users *curUser = [[UsersProvider sharedProvider] currentUser];
    if(curUser == nil || ![defaults boolForKey:kShareYourLocation]){
        return;
    }

    QBLGeoData *geoData = [[QBLGeoData alloc] init];
    geoData.status = curUser.status;
    geoData.latitude = newLocation.coordinate.latitude;
    geoData.longitude = newLocation.coordinate.longitude;

    // post own location
    [QBLocationService postGeoData:geoData delegate:self];
    [geoData release];
}


#pragma mark -
#pragma mark FBSessionDelegate

- (void)fbDidLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:nFBDidLogin object:nil];
}


#pragma mark -
#pragma mark ActionStatusDelegate

- (void)completedWithResult:(Result *)result{

}

-(void)showMessage:(NSString*)title message:(NSString*)msg{
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:msg 
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"OK", "") 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];	
}

-(void)processErrors:(NSArray *)errors{
	NSMutableString *errorsString = [NSMutableString stringWithCapacity:0];
	
	for(NSString *error in errors){
		[errorsString appendFormat:@"%@\n", error];
	}
	
	if ([errorsString length] > 0) {
		[self showMessage:NSLocalizedString(@"Error", "") message:errorsString];
	}
}

- (void)dealloc{
    [_window release];
    [_viewController release];
    [_splashController release];
    [_quizRootController release];
        [facebook release];
    
	[super dealloc];
}

@end