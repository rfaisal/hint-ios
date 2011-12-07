//
//  SuperSampleAppDelegate.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/22/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "SuperSampleAppDelegate.h"

//Data
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


- (void) signIn{
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