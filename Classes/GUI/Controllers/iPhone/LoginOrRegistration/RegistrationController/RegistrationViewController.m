//
//  RegistrationViewController.m
//  SuperSample
//
//  Created by Danil on 04.10.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "RegistrationViewController.h"
#import "UsersProvider.h"
#import "Users.h"
#import "SuperSampleAppDelegate.h"

@implementation RegistrationViewController
@synthesize userName;
@synthesize email;
@synthesize password;
@synthesize retypePassword;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [userName release];
    [email release];
    [password release];
    [retypePassword release];
    [activityIndicator release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setUserName:nil];
    [self setEmail:nil];
    [self setPassword:nil];
    [self setRetypePassword:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)next:(id)sender {
	if ([password.text isEqualToString:@""] ||
		![retypePassword.text isEqualToString:password.text]) 
	{
		[self showMessage:@"Error" message:@"Confirm password is wrong!"];
		return;
	}
    
      if ([password.text length]<6) {
		[self showMessage:@"Error" message:@"Please ensure your password is a minimum of 6 characters"];
		return;
    }
    
     NSCharacterSet *nonNumericCharacters = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    // and check whether there's a character in the string that's not in that set
    if([password.text rangeOfCharacterFromSet:nonNumericCharacters].location != NSNotFound){
        [self showMessage:@"Error" message:@"Please use alpha or numeric characters with no spaces"];
        return;
    }

//    BOOL isInvalidCharacters=NO;
    NSRange rangeValidCharacters;
    rangeValidCharacters.location=(unsigned int)'0';
    rangeValidCharacters.length = 74;
    
    NSCharacterSet * inValidCharacters= [[NSCharacterSet characterSetWithRange:rangeValidCharacters] invertedSet];
//    // and check whether there's a character in the string that's not in that set
    if([password.text rangeOfCharacterFromSet:inValidCharacters].location != NSNotFound){
        [self showMessage:@"Error" message:@"Please use alpha or numeric characters with no spaces"];
		return;

    }

	 
    QBUUser* user = [[QBUUser alloc] init];
    user.ownerID = ownerID;        
    user.email = email.text;
	user.password = password.text;
    user.login = userName.text;
	user.fullName = userName.text;
	user.deviceID = QBBlobOwnerTypeApplication;
	
	[self busy:YES];
	[QBUsersService createUser:user delegate:self context:nil];
    [user release];


}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 1) 
	{
        [(SuperSampleAppDelegate*)[[UIApplication sharedApplication] delegate] signIn];
        
	}
}



#pragma mark Private

-(void)showMessage:(NSString*)title message:(NSString*)msg
{
	[self busy:NO];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:msg 
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"OK", "") 
										  otherButtonTitles:nil];
	
	alert.tag = (title == NSLocalizedString(@"Registration successful", "") ? 1 : 0);
	[alert show];
	[alert release];	
}

-(void)processErrors:(NSMutableArray*)errors
{
	NSMutableString *errorsString = [NSMutableString stringWithCapacity:0];
	
	for(NSString *error in errors)
	{
		[errorsString appendFormat:@"%@\n", error];
	}
	
	if ([errorsString length] > 0) 
	{
		[self showMessage:NSLocalizedString(@"Error", "") message:errorsString];
	}
	else 
	{
		[self busy:NO];
	}
	
}

-(NSString*) valueOfParameter:(NSString*)parameter fromURL:(NSURL*)url separator:(NSString*)separator
{
	NSString *valueSubstring = nil;
	NSRange codeRange = [[url absoluteString] rangeOfString:parameter];
	if (codeRange.length > 0) 
	{
		valueSubstring = [[url absoluteString] substringFromIndex:codeRange.location + codeRange.length];
		NSRange valueEndRange = [valueSubstring rangeOfString:separator];
		if (valueEndRange.length > 0) 
		{
			valueSubstring = [valueSubstring substringToIndex:valueEndRange.location + valueEndRange.length - 1];
		}
	}
	
	return valueSubstring;
}

-(void)busy:(BOOL) _isBusy
{
	if (isBusy) 
	{
		[activityIndicator startAnimating];
	}
	else 
	{
		[activityIndicator stopAnimating];		
	}	
}


#pragma mark ActionStatusDelegate

-(void)completedWithResult:(Result*)result
{
	[self completedWithResult:result context:nil];
}

-(void)completedWithResult:(Result*)result context:(void*)contextInfo
{
	int status = ((RestAnswer*)result.answer).response.status;
	if([result isKindOfClass:[QBUUserResult class]])
	{
		QBUUserResult* res = (QBUUserResult*)result;
		if(res.success && status == 201)
		{
			[self showMessage:NSLocalizedString(@"Registration successful", "") message:nil];
            QBUUserIdentifyAnswer *answer = (QBUUserIdentifyAnswer*)res.answer;
            Users *user = [[UsersProvider sharedProvider] currentUser];
            user.mbUser = answer.user;
            [[UsersProvider sharedProvider] saveUser];

		}
		else if(401 == status)
		{
			[self showMessage:NSLocalizedString(@"Registration failed", "") message:nil];
		}
		else if(422 == status)
		{
			[self processErrors:result.answer.errors];
		}
		else
		{
			[self processErrors:result.answer.errors];
		}
	}	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [password resignFirstResponder];
    [email resignFirstResponder];
    [retypePassword resignFirstResponder];
    [userName resignFirstResponder];
}

@end
