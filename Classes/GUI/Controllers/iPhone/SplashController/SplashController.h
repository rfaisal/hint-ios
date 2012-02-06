//
//  SplashController.h
//  SuperSample
//
//  Created by Danil on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SubscribedViewController.h"

@interface SplashController : SubscribedViewController <ActionStatusDelegate>{
    UIActivityIndicatorView *wheel;
    NSTimer *timer;
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *wheel;

- (void)hideSplash;

@end