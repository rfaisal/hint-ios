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
    if(timer == nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerSelector:) userInfo:nil repeats:NO];
    }
}

- (void) viewDidLoad{
    [super viewDidLoad];
    [FlurryAPI logEvent:@"SplashController, viewDidLoad"];
    
    // Auth App
    [QBAuthService authorizeAppId:appID key:authKey secret:authSecret delegate:self];
}

- (void)timerSelector:(NSTimer*)theTimer{
    timer = nil;
    
    if([BaseService sharedService].token){
        [self hideSplash];
    }
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
            if(timer == nil){
                [self hideSplash];
            }
        }else{
            [self processErrors:result.errors];
        }
    }
}

@end