//
//  LoginOrRegistrationViewController.h
//  SuperSample
//
//  Created by Danil on 04.10.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "SubscribedViewController.h"
@class LoginViewController;
@class RegistrationViewController;

@interface LoginOrRegistrationViewController : SubscribedViewController {
    
    RegistrationViewController *registrationController;
    LoginViewController *loginController;
}

@property (nonatomic, retain) IBOutlet RegistrationViewController *registrationController;
@property (nonatomic, retain) IBOutlet LoginViewController *loginController;

- (IBAction)openLoginController:(id)sender;
- (IBAction)openRegistrationController:(id)sender;
- (IBAction)proceedToApp:(id)sender;

@end
