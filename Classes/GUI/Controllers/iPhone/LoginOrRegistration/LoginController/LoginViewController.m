//
//  LoginViewController.m
//  SuperSample
//
//  Created by Danil on 04.10.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "LoginViewController.h"
#import "UsersProvider.h"
#import "SuperSampleAppDelegate.h"
#import "Users.h"

@implementation LoginViewController
@synthesize login;
@synthesize password;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [login release];
    [password release];
    [activityIndicator release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidUnload{
    [self setLogin:nil];
    [self setPassword:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)next:(id)sender {
	if (isBusy) {
		return;
	}
    
    QBUUser *qbUser = [[QBUUser alloc] init];
    qbUser.ownerID = ownerID;        
    qbUser.login = login.text;
	qbUser.password = password.text;
    
    // authenticate
    [QBUsersService authenticateUser:qbUser delegate:self context:nil];
    
    [qbUser release];
    
    [self busy:YES];
}

- (IBAction)back:(id)sender {
	if (isBusy) {
		return;
	}

    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark ActionStatusDelegate

-(void)completedWithResult:(Result*)result{
	[self completedWithResult:result context:nil];
}

-(void)completedWithResult:(Result*)result context:(void*)contextInfo{
	int status = ((RestAnswer*)result.answer).response.status;
    
	if([result isKindOfClass:[QBUUserAuthenticateResult class]]){
		QBUUserAuthenticateResult* res = (QBUUserAuthenticateResult *)result;
		if(res.success){
            // identify User
			[QBUsersService identifyUser:self context:nil];
		}else if(401 == status){
			[self showMessage:NSLocalizedString(@"Not registered!", "") message:nil];
		}else if(422 == status){
			[self processErrors:result.answer.errors];
		}
        
	}else if([result isKindOfClass:[QBUUserIdentifyResult class]]){
		QBUUserIdentifyResult* res = (QBUUserIdentifyResult *)result;
        
		if(res.success && 200 == status){
			QBUUserIdentifyAnswer *answer = (QBUUserIdentifyAnswer *)res.answer;
                  
            // fix issue with sign in
            if(answer.user.ownerID != ownerID){
                [self showMessage:NSLocalizedString(@"Not registered!", "") message:nil];
                return;
            }
            
            // current user
            Users *user = [[UsersProvider sharedProvider] currentUserWithQBUser:answer.user];

            [[NSNotificationCenter defaultCenter] postNotificationName:nRefreshAnnotationDetails object:nil];
            
			[self showMessage:NSLocalizedString(@"Authentication successful", "") 
					  message:[NSString stringWithFormat:NSLocalizedString(@"%@ was authenticated", ""), answer.user.fullName]];
 
		}else if(401 == status){			
			[self showMessage:NSLocalizedString(@"Identification failed", "") message:nil];
		}	else if(422 == status){
			[self processErrors:result.answer.errors];
		}
	
    }else if([result isKindOfClass:[QBUUserBaseWebAuthResult class]]){
		QBUUserBaseWebAuthResult* res = (QBUUserBaseWebAuthResult *)result;
        
		if(res.success && 202 == status){
			[QBUsersService identifyUser:self context:nil];
		}else if(401 == status){			
			[self showMessage:NSLocalizedString(@"Identification failed", "") message:nil];
		}	else if(422 == status){
			[self processErrors:result.answer.errors];
		}
        
	}else if([result isKindOfClass:[QBUUserResetPasswordByEmailResult class]]){
		QBUUserResetPasswordByEmailResult* res = (QBUUserResetPasswordByEmailResult*)result;
		if(res.success && 200 == status){
			[self showMessage:NSLocalizedString(@"Your new password or resetting instructions has been mailed", "") message:nil];
			//You will receive an email with instructions about how to reset your password in a few minutes. 
		}else if(404 == status){			
			[self showMessage:NSLocalizedString(@"Email not found", "") message:nil];
		}else if(422 == status){
			[self processErrors:result.answer.errors];
		}
	}
}


#pragma mark -
#pragma mark Private

-(void)showMessage:(NSString*)title message:(NSString*)msg{
	[self busy:NO];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:msg 
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"OK", "") 
										  otherButtonTitles:nil];
	alert.tag = (title == NSLocalizedString(@"Authentication successful", "") ? 1 : 0);
	[alert show];
	[alert release];	
}

-(void)processErrors:(NSMutableArray*)errors{
	NSMutableString *errorsString = [NSMutableString stringWithCapacity:0];
	
	for(NSString *error in errors){
		[errorsString appendFormat:@"%@\n", error];
	}
	
	if ([errorsString length] > 0) {
		[self showMessage:NSLocalizedString(@"Error", "") message:errorsString];
	}else {
		[self busy:NO];
	}	
}

-(void)busy:(BOOL) _isBusy{	
	isBusy = _isBusy;
	
	if (isBusy) {
		[activityIndicator startAnimating];
	}else {
		[activityIndicator stopAnimating];		
	}	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [password resignFirstResponder];
    [login resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 1) {
        [(SuperSampleAppDelegate*)[[UIApplication sharedApplication] delegate] signIn];
	}
}

@end