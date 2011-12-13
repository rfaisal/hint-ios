//
//  SuperSampleAppDelegate.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/22/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "SuperSampleAppDelegate.h"

//Helpers

#import "UsersProvider.h"
#import "Users.h"

//UI
#import "LoginOrRegistrationViewController.h"


@implementation SuperSampleAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize loginOrRegisterController = _loginOrRegisterController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    // QB settings
	[QBSettings setLogLevel:QBLogLevelDebug];
	[QBSettings setServerDomainTemplate:[NSString stringWithFormat:@"%@%@", @"%@.", endpoint]];	
    
    [QBGeoposService setDomain:@"location.qbtest01.quickblox.com"];
	[QBGeoposService AuthorizeAppId:appID key:appKey secret:appSecret];	
	[QBGeoposService setServiceZone:ServiceZoneProduction];

	[QBUsersService AuthorizeAppId:appID key:appKey secret:appSecret];
    [QBUsersService setServiceZone:ServiceZoneProduction];
		
	[QBBlobsService AuthorizeAppId:appID key:appKey secret:appSecret];	
	[QBBlobsService setServiceZone:ServiceZoneProduction];
	
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [self.viewController presentModalViewController:self.loginOrRegisterController animated:NO];
    
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


- (void) signIn{
    // start handling own location
    [self startHadleOwnLocation];
    
    // show main screen
    [self.viewController dismissModalViewControllerAnimated:YES];
}

- (IBAction) logout{
    // logout
    [QBUsersService logoutUser:nil];
    [[UsersProvider sharedProvider] setCurrentUserID:-1];
    
    // stop handling own location
    [self stopHadleOwnLocation];
    
    // shoe start screen
    [self.viewController presentModalViewController:self.loginOrRegisterController animated:YES];
}

- (void)startHadleOwnLocation{
    [[QBLocationDataSource instance] setCallbackSelectorForLocationUpdate:@selector(didUpdateToLocation:fromLocation:) forTarget:self];
    [[[QBLocationDataSource instance] locationManager] startUpdatingLocation];
}

- (void)stopHadleOwnLocation{
    [[QBLocationDataSource instance] setCallbackSelectorForLocationUpdate:nil forTarget:nil];
    [[[QBLocationDataSource instance] locationManager] stopUpdatingLocation];
}

- (void)didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"Location didUpdate from %@ to %@", oldLocation, newLocation);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 

    Users *curUser = [[UsersProvider sharedProvider] currentUser];
    if(curUser == nil || ![defaults boolForKey:kShareYourLocation]){
        return;
    }

    QBGeoData *geoData = [[QBGeoData alloc] init];
    geoData.appID = appID;
    geoData.user = [curUser mbUser];
    geoData.status = curUser.status;
    geoData.latitude = newLocation.coordinate.latitude;
    geoData.longitude = newLocation.coordinate.longitude;

    // post own location
    [QBGeoposService postGeoData:geoData delegate:self];
    [geoData release];
}


#pragma mark
#pragma mark ActionStatusDelegate
#pragma mark

- (void)completedWithResult:(Result *)result{
	if(result.success){
		if([result isKindOfClass:[QBGeoDataResult class]]){
			//QBGeoDataResult *geoDataRes = (QBGeoDataResult *)result;
		}
	}
}

- (void)dealloc{
    [_window release];
    [_viewController release];
    [_loginOrRegisterController release];
    
	[super dealloc];
}

@end