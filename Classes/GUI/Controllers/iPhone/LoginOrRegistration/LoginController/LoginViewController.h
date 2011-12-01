//
//  LoginViewController.h
//  SuperSample
//
//  Created by Danil on 04.10.11.
//  Copyright 2011 YAS. All rights reserved.
//


#import "SubscribedViewController.h"



@interface LoginViewController : SubscribedViewController<ActionStatusDelegate> {
    
    UITextField *login;
    UITextField *password;
    UIActivityIndicatorView *activityIndicator;
    BOOL isBusy;

}
@property (nonatomic, retain) IBOutlet UITextField *login;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)next:(id)sender;
- (IBAction)back:(id)sender;

-(void)busy:(BOOL) isBusy;
-(void)showMessage:(NSString*)title message:(NSString*)msg;
-(void)processErrors:(NSMutableArray*)errors;


@end
