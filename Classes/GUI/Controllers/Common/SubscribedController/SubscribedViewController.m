//
//  SubscribedViewController.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SubscribedViewController.h"

@interface SubscribedViewController () 

@property (nonatomic, retain) SubscribedViewController *modalCustomViewController;

- (void) presentCustomModalViewControllerDidEndAnimation;
- (void) dismissCustomModalViewControllerDidEndAnimation;

@end


@implementation SubscribedViewController

@synthesize innerInterfaceOrientation;
@synthesize parentCustomModalController;
@synthesize modalCustomViewController;

- (void) dealloc {
	[self unsubscribe];
	[self releaseAll];
	
	[super dealloc];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	self.innerInterfaceOrientation = toInterfaceOrientation;
}

- (void) viewDidLoad {
    [super viewDidLoad];
	
	[self subscribe];
	[self startInit];
}

- (void) viewDidUnload {
    [super viewDidUnload];
    
    [self unsubscribe];
	[self releaseProperties];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) subscribe {}
- (void) unsubscribe {}

- (void) startInit {
    self.innerInterfaceOrientation = UIInterfaceOrientationPortrait;
}

- (void) releaseProperties {
    self.parentCustomModalController = nil;
    self.modalCustomViewController = nil;
}
- (void) releaseAll {
    [self releaseProperties];
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (NSString*) controllerName{
	return [NSString stringWithFormat:@"%@", [self class]];
}


#pragma mark -
#pragma mark Custom Modal View

- (void) presentCustomModalViewControllerDidEndAnimation {
    [self.modalCustomViewController viewDidAppear:YES];
}

- (void) dismissCustomModalViewControllerDidEndAnimation {
    [self.modalCustomViewController viewDidDisappear:YES];
    [self.modalCustomViewController.view removeFromSuperview];
    
    self.modalCustomViewController.parentCustomModalController = nil;
    self.modalCustomViewController = nil;
}

- (void) presentCustomModalViewController:(SubscribedViewController*)controller animated:(BOOL)animated {
    self.modalCustomViewController = controller;
    self.modalCustomViewController.parentCustomModalController = self;
    
    self.modalCustomViewController.view.frame = self.view.bounds;
	self.modalCustomViewController.view.alpha = 0;
    
	[self.view addSubview:self.modalCustomViewController.view];
    
    [self.modalCustomViewController viewWillAppear:animated];
	
    if (animated) {
        [UIView beginAnimations:@"show modal View" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(presentCustomModalViewControllerDidEndAnimation)];
    }
	
	self.modalCustomViewController.view.alpha = 1;
	
    if (animated) {
        [UIView commitAnimations];
    } else {
        [self.modalCustomViewController viewDidAppear:animated];
    }
}

- (void) dismissCustomModalViewControllerAnimated:(BOOL)animated {
    [self.modalCustomViewController viewWillDisappear:animated];
    
    if (animated) {
        [UIView beginAnimations:@"hide modal View" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(dismissCustomModalViewControllerDidEndAnimation)];
    }
	
	self.modalCustomViewController.view.alpha = 0;
	
    if (animated) {
        [UIView commitAnimations];
    } else {
        [self.modalCustomViewController viewDidDisappear:animated];
        [self.modalCustomViewController.view removeFromSuperview];
        
        self.modalCustomViewController.parentCustomModalController = nil;
        self.modalCustomViewController = nil;
    }
}

-(void)showMessage:(NSString*)title message:(NSString*)msg delegate:(id)delegate{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:msg 
												   delegate:delegate 
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
		[self showMessage:NSLocalizedString(@"Error", "") message:errorsString delegate:nil];
	}
}

@end