//
//  SubscribedViewController.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "SubscribedViewController.h"

@interface SubscribedViewController () 

@property (nonatomic, retain) SubscribedViewController *modalCustomViewController;

- (void) presentCustomModalViewControllerDidEndAnimation;
- (void) dismissCustomModalViewControllerDidEndAnimation;

@end


@implementation SubscribedViewController

@synthesize innerInterfaceOrientation;
//@synthesize activityView;
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
    
    //    if ([RBSettings sharedRBSettings].logLevel == RBLogLevelInfo)
    //        DL(@"Did Unload View Controller: %@", [[self class] description]);
    
    [self unsubscribe];
	[self releaseProperties];
}

- (void) viewDidAppear:(BOOL)animated {
    //    if ([RBSettings sharedRBSettings].logLevel == RBLogLevelInfo)
    //        DL(@"Did Appear View: %@", [[self class] description]);
    [super viewDidAppear:animated];
}
- (void) viewDidDisappear:(BOOL)animated {
    //    if ([RBSettings sharedRBSettings].logLevel == RBLogLevelInfo)
    //        DL(@"Did Disapear View: %@", [[self class] description]);
    [super viewDidDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated {
    //    if ([RBSettings sharedRBSettings].logLevel == RBLogLevelInfo)
    //        DL(@"View: %@ will Appear", [[self class] description]);
    [super viewWillAppear:animated];
}
- (void) viewWillDisappear:(BOOL)animated {
    //    if ([RBSettings sharedRBSettings].logLevel == RBLogLevelInfo)
    //        DL(@"View: %@ will Disappear", [[self class] description]);
    [super viewWillDisappear:animated];
}

- (void) subscribe {}
- (void) unsubscribe {}

- (void) startInit {
    self.innerInterfaceOrientation = UIInterfaceOrientationPortrait;
}
- (void) releaseProperties {
    //	self.activityView = nil;
    self.parentCustomModalController = nil;
    self.modalCustomViewController = nil;
}
- (void) releaseAll {
    [self releaseProperties];
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
    
    //    if ([RBSettings sharedRBSettings].logLevel == RBLogLevelInfo)
    //        DL(@"Class: %@ did receive Memory Warning", [[self class] description]);
}

- (NSString*) controllerName{
	return [NSString stringWithFormat:@"%@", [self class]];
}

#pragma mark -
#pragma mark ActivityView

/*- (void) showActivityView {
 [self hideActivityView];
 
 self.activityView = [ActivityView showAtView:self.view];
 }
 - (void) hideActivityView {
 if (self.activityView)
 [self.activityView hide];
 self.activityView = nil;
 }*/

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

@end
