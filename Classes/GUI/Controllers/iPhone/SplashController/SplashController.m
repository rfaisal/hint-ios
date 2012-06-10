//
//  SplashController.m
//  SuperSample
//
//  Created by Danil on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SplashController.h"

#import "SuperSampleAppDelegate.h"

@implementation SplashController
@synthesize wheel = _wheel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidUnload{
    self.wheel = nil;

    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    [FlurryAPI logEvent:@"SplashController, viewDidLoad"];
    
     // Create extended application authorization request (for push notifications)
    QBASessionCreationRequest *extendedAuthRequest = [[QBASessionCreationRequest alloc] init];
    extendedAuthRequest.devicePlatorm = DevicePlatformiOS;
    extendedAuthRequest.deviceUDID = [[UIDevice currentDevice] uniqueIdentifier];
    
    // QuickBlox application authorization
    [QBAuthService authorizeAppId:appID key:authKey secret:authSecret withExtendedRequest:extendedAuthRequest delegate:self];
    
    [extendedAuthRequest release];
}

- (void)hideSplash{
    // hide splash & show main controller
    [self dismissModalViewControllerAnimated:YES];     
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark ActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result *)result{
    
    // QuickBlox application authorization result
    if([result isKindOfClass:[QBAAuthSessionCreationResult class]]){
        
        // Success result
        if(result.success){
            // Hide splash & show main controller
            [self performSelector:@selector(hideSplash) withObject:nil afterDelay:2];
        }else{
            // show Errors
            [self processErrors:result.errors];
        }
    }
}

@end