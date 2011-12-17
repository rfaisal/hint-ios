//
//  SuperSampleAppDelegate.h
//  SuperSample
//
//  Created by Andrey Kozlov on 8/22/11.
//  Copyright 2011 YAS. All rights reserved.
//


@class SuperSampleViewController;
@class LoginOrRegistrationViewController;
@class QuizRootViewController;

@interface SuperSampleAppDelegate : NSObject <UIApplicationDelegate, ActionStatusDelegate>{		
    LoginOrRegistrationViewController *_loginOrRegisterController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UIViewController *viewController;
@property (nonatomic, retain) IBOutlet LoginOrRegistrationViewController *loginOrRegisterController;
@property (nonatomic, retain) IBOutlet QuizRootViewController *quizRootController;



- (void) signIn;
- (IBAction) logout;

- (void) startTrackOwnLocation;
- (void) stopTrackOwnLocation;
- (void) didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

@end
