//
//  LoginViewController.h
//  SuperSample
//
//  Created by Igor Khomenko on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SubscribedViewController.h"
#import "FBConnect.h"

@interface LoginViewController : SubscribedViewController <QBActionStatusDelegate, UIAlertViewDelegate, UITextFieldDelegate, FBRequestDelegate> {    
    UITextField *login;
    UITextField *password;
    UIActivityIndicatorView *activityIndicator;
    BOOL isBusy;
}
@property (nonatomic, retain) IBOutlet UITextField *login;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIButton *fbLoginButton;
@property (nonatomic, retain) NSDictionary *fbUserBody;

- (IBAction)next:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)authViaFacebook:(id)sender;

-(void)busy:(BOOL) isBusy;

@end