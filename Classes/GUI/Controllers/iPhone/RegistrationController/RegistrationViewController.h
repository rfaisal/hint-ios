//
//  RegistrationViewController.h
//  SuperSample
//
//  Created by Igor Khomenko on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SubscribedViewController.h"


@interface RegistrationViewController : SubscribedViewController <ActionStatusDelegate, UIAlertViewDelegate, UITextFieldDelegate> {
    UITextField *userName;
    UITextField *password;
    UITextField *retypePassword;
    UIActivityIndicatorView *activityIndicator;
    
    BOOL isBusy;
}
@property (nonatomic, retain) IBOutlet UITextField *userName;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UITextField *retypePassword;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)next:(id)sender;
- (IBAction)back:(id)sender;

-(void)busy:(BOOL) isBusy;

@end