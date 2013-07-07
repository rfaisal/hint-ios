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
#import "NumberToLetterConverter.h"

@implementation LoginViewController
@synthesize login;
@synthesize password;
@synthesize activityIndicator;
@synthesize fbLoginButton;
@synthesize fbUserBody;

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
    [fbUserBody release];
    [super dealloc];
}


#pragma mark -
#pragma mark - View lifecycle

- (void) viewDidLoad{
    [super viewDidLoad];
    [FlurryAPI logEvent:@"LoginViewController, viewDidLoad"];
    
    // Login Button
    [fbLoginButton setImage:[UIImage imageNamed:@"FBConnect.bundle/images/LoginNormal@2x.png"]
                 forState:UIControlStateNormal];
    [fbLoginButton setImage:[UIImage imageNamed:@"FBConnect.bundle/images/LoginPressed@2x.png"]
                 forState:UIControlStateHighlighted];
    [fbLoginButton sizeToFit];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(fbDidLogin:) 
                                                 name:nFBDidLogin object:nil];
}

- (void)viewDidUnload{
    [self setLogin:nil];
    [self setPassword:nil];
    [self setActivityIndicator:nil];
    self.fbLoginButton = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nFBDidLogin object:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// User Sign In
- (IBAction)next:(id)sender {
	if (isBusy) {
		return;
	}

    // Authenticate user
    [QBUsers logInWithUserLogin:login.text password:password.text delegate:self];
    
    [self busy:YES];
}

- (IBAction)back:(id)sender {
	if (isBusy) {
		return;
	}

    [self dismissModalViewControllerAnimated:YES];
}

// Auth via Facebook action
- (IBAction)authViaFacebook:(id)sender{
    
    SuperSampleAppDelegate *delegate = ((SuperSampleAppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    if (![[delegate facebook] isSessionValid]) {
        [[delegate facebook] authorize:nil];
        
        [self busy:YES];
    } 
}

// Facebook auth was successful
- (void)fbDidLogin:(NSNotification *)notification{
    SuperSampleAppDelegate *delegate = ((SuperSampleAppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    // get information about the currently logged in user
    [[delegate facebook] requestWithGraphPath:@"me" andDelegate:self];
}


#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didLoad:(id)result{
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:result];
    self.fbUserBody = dict;

    // try to auth
    NSString *userLogin = [[NumberToLetterConverter instance] convertNumbersToLetters:[fbUserBody objectForKey:@"id"]];
    NSString *passwordHash = [NSString stringWithFormat:@"%u", [[fbUserBody objectForKey:@"id"] hash]];

    // Authenticate user
    [QBUsers logInWithUserLogin:userLogin password:passwordHash delegate:self];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result *)result{

    [self busy:NO];
    
     // QuickBlox User authenticate result
	if([result isKindOfClass:[QBUUserLogInResult class]]){

        // Success result
		if(result.success){
            QBUUserLogInResult *res = (QBUUserLogInResult *)result;
            
            // save current user
            [[UsersProvider sharedProvider] currentUserWithQBUser:res.user];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:nRefreshAnnotationDetails object:nil];
            
            NSString *userName;
            if(fbUserBody){
                userName = [fbUserBody objectForKey:@"name"];
            }else{
                userName = res.user.login;
            }
			[self showMessage:NSLocalizedString(@"Authentication successful", "") 
					  message:[NSString stringWithFormat:NSLocalizedString(@"%@ was authenticated", ""), userName] delegate:self];
            
            
            self.fbUserBody = nil;

        // Errors
		}else if(401 == result.status){
            
            if(fbUserBody){
                // Register new user
                // Create QBUUser entity
                QBUUser *user = [QBUUser user];      
                NSString *userLogin = [[NumberToLetterConverter instance] convertNumbersToLetters:[fbUserBody objectForKey:@"id"]];
                NSString *passwordHash = [NSString stringWithFormat:@"%u", [[fbUserBody objectForKey:@"id"] hash]]; 
                user.login = userLogin;
                user.password = passwordHash;
                user.facebookID = [fbUserBody objectForKey:@"id"];
                user.fullName = [fbUserBody objectForKey:@"name"];
                
                // Create user
                [QBUsers signUp:user delegate:self];
                
                [self busy:YES];
                
            }else{
                [self showMessage:NSLocalizedString(@"Not registered!", "") message:nil delegate:nil];
            }
            
        // Show Errors
		}else{
            [self processErrors:result.errors];
        }
        
    // Create user result
    }else if([result isKindOfClass:[QBUUserResult class]]){

        // Success result
		if(result.success){
            
            // auth again
            NSString *userLogin = [[NumberToLetterConverter instance] convertNumbersToLetters:[fbUserBody objectForKey:@"id"]];
            NSString *passwordHash = [NSString stringWithFormat:@"%u", [[fbUserBody objectForKey:@"id"] hash]];
            
            // authenticate user
            [QBUsers logInWithUserLogin:userLogin password:passwordHash delegate:self];
            
            [self busy:YES];
            
        // show Errors
        }else{
            [self processErrors:result.errors];
        }
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    [_textField resignFirstResponder];
    [self next:nil];
    return YES;
}


#pragma mark -
#pragma mark Private

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
    
    // Register user for receive push notifications
    [QBMessages TRegisterSubscriptionWithDelegate:self];

    [(SuperSampleAppDelegate *)[[UIApplication sharedApplication] delegate] startTrackOwnLocation];
    [self dismissModalViewControllerAnimated:YES];
}

@end