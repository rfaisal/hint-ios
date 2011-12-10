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

    SubscribedViewController *parentCustomModalController;
    SubscribedViewController *modalCustomViewController;
}

@property (nonatomic, assign) UIInterfaceOrientation innerInterfaceOrientation;
@property (nonatomic, retain) SubscribedViewController *parentCustomModalController;

#pragma mark Subscription

- (void) subscribe;
- (void) unsubscribe;

#pragma mark Life Cicle

- (void) startInit;
- (void) releaseProperties;
- (void) releaseAll;

- (NSString*) controllerName;

#pragma mark Custom Modal View

- (void) presentCustomModalViewController:(SubscribedViewController*)controller animated:(BOOL)animated;
- (void) dismissCustomModalViewControllerAnimated:(BOOL)animated;

@end