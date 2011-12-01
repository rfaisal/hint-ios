//
//  SubscribedViewController.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscribedViewController : UIViewController {
    UIInterfaceOrientation innerInterfaceOrientation;
	//ActivityView *activityView;
    
    SubscribedViewController *parentCustomModalController;
    SubscribedViewController *modalCustomViewController;
}

@property (nonatomic, assign) UIInterfaceOrientation innerInterfaceOrientation;

//@property (nonatomic, retain) ActivityView *activityView;
@property (nonatomic, retain) SubscribedViewController *parentCustomModalController;

#pragma mark Subscription

- (void) subscribe;
- (void) unsubscribe;

#pragma mark Life Cicle

- (void) startInit;
- (void) releaseProperties;
- (void) releaseAll;

- (NSString*) controllerName;

#pragma mark ActivityView

//- (void) showActivityView;
//- (void) hideActivityView;

#pragma mark Custom Modal View

- (void) presentCustomModalViewController:(SubscribedViewController*)controller animated:(BOOL)animated;
- (void) dismissCustomModalViewControllerAnimated:(BOOL)animated;

@end
