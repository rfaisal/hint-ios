//
//  RegistrationViewController.m
//  SuperSample
//
//  Created by Igor Khomenko on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "RegistrationViewController.h"
#import "UsersProvider.h"
#import "Users.h"
#import "SuperSampleAppDelegate.h"

@implementation RegistrationViewController
@synthesize userName;
@synthesize password;
@synthesize retypePassword;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [userName release];
    [password release];
    [retypePassword release];
    [activityIndicator release];
    [super dealloc];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    [FlurryAPI logEvent:@"RegistrationViewController, viewDidLoad"];
}

- (void)viewDidUnload{
    [self setUserName:nil];
    [self setPassword:nil];
    [self setRetypePassword:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// User Sign Up
- (IBAction)next:(id)sender {
    
    // Validation
    if([[userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        [self showMessage:@"Error" message:@"Please enter your login!" delegate:nil];
		return;
    }
    if([[password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        [self showMessage:@"Error" message:@"Please enter your password!" delegate:nil];
		return;
    }
    
	if (![retypePassword.text isEqualToString:password.text]) {
		[self showMessage:@"Error" message:@"Confirm password is wrong!" delegate:nil];
		return;
	}
    
    if ([password.text length] < 3) {
		[self showMessage:@"Error" message:@"Please ensure your password is a minimum of 3 characters" delegate:nil];
		return;
    }
    
    NSCharacterSet *nonNumericCharacters = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if([password.text rangeOfCharacterFromSet:nonNumericCharacters].location != NSNotFound){
        [self showMessage:@"Error" message:@"Please use alpha or numeric characters with no spaces in password field" delegate:nil];
        return;
    }

    NSRange rangeValidCharacters;
    rangeValidCharacters.location=(unsigned int)'0';
    rangeValidCharacters.length = 74;
    
    NSCharacterSet * inValidCharacters= [[NSCharacterSet characterSetWithRange:rangeValidCharacters] invertedSet];
    if([password.text rangeOfCharacterFromSet:inValidCharacters].location != NSNotFound){
        [self showMessage:@"Error" message:@"Please use alpha or numeric characters with no spaces in password field" delegate:nil];
		return;
    }
	 
    // Create QuickBlox User entity
    QBUUser* user = [[QBUUser alloc] init];
    user.ownerID = ownerID;        
	user.password = password.text;
    user.login = userName.text;
	
	[self busy:YES];
    
    // create User
	[QBUsersService createUser:user delegate:self context:nil];
    [user release];
}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)busy:(BOOL) _isBusy{
    isBusy = _isBusy;
    
	if (isBusy) {
		[activityIndicator startAnimating];
	}else {
		[activityIndicator stopAnimating];		
	}	
}


#pragma mark -
#pragma mark ActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result*)result{
	[self completedWithResult:result context:nil];
}

-(void)completedWithResult:(Result*)result context:(void*)contextInfo{
    // QuickBlox User creation result
	if([result isKindOfClass:[QBUUserResult class]]){
        
        // Success result
		if(result.success){
			[self showMessage:NSLocalizedString(@"Registration successful. Please now sign in.", "") message:nil delegate:self];
            
        // show Errors
		}else {
			[self processErrors:result.errors];
		}
	}	
    
    [self busy:NO];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    [_textField resignFirstResponder];
    [self next:nil];
    return YES;
}


#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     [self dismissModalViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [password resignFirstResponder];
    [retypePassword resignFirstResponder];
    [userName resignFirstResponder];
}

@end