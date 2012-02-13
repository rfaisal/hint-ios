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
    
    // Auth App
    [QBAuthService authorizeAppId:appID key:authKey secret:authSecret delegate:self];
}

- (void)hideSplash{
    [self dismissModalViewControllerAnimated:YES];     
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark ActionStatusDelegate

- (void)completedWithResult:(Result *)result{
    
    if([result isKindOfClass:[QBAAuthSessionCreationResult class]]){
        if(result.success){
            [self performSelector:@selector(hideSplash) withObject:nil afterDelay:2];
        }else{
            [self processErrors:result.errors];
        }
    }
}

@end