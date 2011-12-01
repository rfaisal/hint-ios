//
//  RegistrationViewController.h
//  SuperSample
//
//  Created by Danil on 04.10.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "SubscribedViewController.h"


@interface RegistrationViewController : SubscribedViewController <ActionStatusDelegate> {
    
    UITextField *userName;
    UITextField *email;
    UITextField *password;
    UITextField *retypePassword;
    UIActivityIndicatorView *activityIndicator;
    
    BOOL isBusy;
}
@property (nonatomic, retain) IBOutlet UITextField *userName;
@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UITextField *retypePassword;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)next:(id)sender;
- (IBAction)back:(id)sender;

-(void)processErrors:(NSMutableArray*)errors;
-(void)showMessage:(NSString*)title message:(NSString*)msg;
-(void)busy:(BOOL) isBusy;


@end
