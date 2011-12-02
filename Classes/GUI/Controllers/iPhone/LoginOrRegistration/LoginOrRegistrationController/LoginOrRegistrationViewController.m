//
//  LoginOrRegistrationViewController.m
//  SuperSample
//
//  Created by Danil on 04.10.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "LoginOrRegistrationViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"

#import "SuperSampleAppDelegate.h"

@implementation LoginOrRegistrationViewController
@synthesize registrationController;
@synthesize loginController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [registrationController release];
    [loginController release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidUnload{
    [self setRegistrationController:nil];
    [self setLoginController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)openLoginController:(id)sender {
    [self presentModalViewController:loginController animated:YES];
}

- (IBAction)openRegistrationController:(id)sender {
    [self presentModalViewController:registrationController animated:YES];
}

@end