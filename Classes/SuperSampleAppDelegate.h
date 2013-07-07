//
//  SuperSampleAppDelegate.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/22/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "FBConnect.h"

@class SuperSampleViewController;
@class SplashController;
@class QuizRootViewController;

@interface SuperSampleAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate>{	
    Facebook *facebook;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *viewController;
@property (nonatomic, retain) IBOutlet SplashController *splashController;
@property (nonatomic, retain) IBOutlet QuizRootViewController *quizRootController;
@property (nonatomic, retain) Facebook *facebook;

- (void) startTrackOwnLocation;
- (void) stopTrackOwnLocation;
- (void) didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

-(void)showMessage:(NSString*)title message:(NSString*)msg;

@end
