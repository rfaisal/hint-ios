//
//  LoginViewController.m
//  SuperSample
//
//  Created by Igor Khomenko on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
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


#pragma mark
#pragma mark - View lifecycle
#pragma mark

- (void) viewDidLoad{
    [super viewDidLoad];
    [FlurryAPI logEvent:@"LoginViewController, viewDidLoad"];
}

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


#pragma mark
#pragma mark ActionStatusDelegate
#pragma mark

-(void)completedWithResult:(Result *)result{
	[self completedWithResult:result context:nil];
}

-(void)completedWithResult:(Result *)result context:(void*)contextInfo{

	if([result isKindOfClass:[QBUUserAuthenticateResult class]]){
		QBUUserAuthenticateResult *res = (QBUUserAuthenticateResult *)result;
        [res user];
		if(res.success){

			QBUUserAuthenticateAnswer *answer = (QBUUserAuthenticateAnswer *)res.answer;
            
            // fix issue with sign in
            if(answer.user.ownerID != ownerID){
                [self showMessage:NSLocalizedString(@"Not registered!", "") message:nil delegate:nil];
                return;
            }
            
            // current user
            [[UsersProvider sharedProvider] currentUserWithQBUser:answer.user];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:nRefreshAnnotationDetails object:nil];
            
			[self showMessage:NSLocalizedString(@"Authentication successful", "") 
					  message:[NSString stringWithFormat:NSLocalizedString(@"%@ was authenticated", ""), answer.user.login] delegate:self];

		}else if(401 == result.status){
			[self showMessage:NSLocalizedString(@"Not registered!", "") message:nil delegate:nil];
		}else{
            [self processErrors:result.errors];
        }
    }
    
    [self busy:NO];
}


#pragma mark
#pragma mark UITextFieldDelegate
#pragma mark

- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    [_textField resignFirstResponder];
    [self next:nil];
    return YES;
}


#pragma mark -
#pragma mark Private
#pragma mark

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
    [(SuperSampleAppDelegate *)[[UIApplication sharedApplication] delegate] startTrackOwnLocation];
    [self dismissModalViewControllerAnimated:YES];
}

@end