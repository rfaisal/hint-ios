//
//  ChatViewController.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "ChatViewController.h"

//Data
#import "Messages.h"
#import "UsersProvider.h"
#import "ChatListProvider.h"
#import "StorageProvider.h"
#import "Users.h"

//Helpers
#import "SSLocationDataSource.h"

//XMPP
#import "XMPPService.h"

//Controllers
#import "PrivateChatViewController.h"

@implementation ChatViewController
@synthesize chatDataSource;
@synthesize tabView;
@synthesize textField;
@synthesize privateChatController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


-(void)subscribe{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openChatView:) name:nOpenChatView object:nil];
    [super subscribe];
}

-(void)unsubscribe{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nOpenChatView object:nil];
    [super unsubscribe];
}

-(void)openChatView:(NSNotification*)notification
{
    [self.navigationController pushViewController:self.privateChatController animated:YES];
    self.privateChatController.objectID = [[notification userInfo] objectForKey:nkData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [chatDataSource reloadData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.tabView addGestureRecognizer:tap];

}


- (void)viewDidUnload
{
    [self setTextField:nil];
    self.privateChatController=nil;
    [self setChatDataSource:nil];
    [self setTabView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark IBActions

-(IBAction) sendAction:(id)sender{
    
    if ([textField.text isEqualToString:@""]) 
	{
        return;
    }    
    
    Users* user = [[UsersProvider sharedProvider] currentUser];
    
	int userID = user.mbUser.ID;
	QBGeoData *geoData = [QBGeoData currentGeoData];
    
	//WARNING We should use User from GeoData. Is is temporarily fix. 
	/*geoData.user = [User GetUser:userID].user;
    if(geoData.user==nil)
	{
        User *geoDataUser = [[User alloc] init];
        geoDataUser.ID = userID;
        geoDataUser.name = [[CurrentUser curentUser] mbUser].login;
        geoData.user = [User CreateUser:geoDataUser].user;
		[geoDataUser release];
    }*/

	QBUser *geoDataUser = [[QBUser alloc] init];
	geoDataUser.ID = userID;
	geoDataUser.name = user.mbUser.login;
	geoData.user = geoDataUser;
	[geoDataUser release];
	
	[QBGeoposService postGeoData:geoData delegate:self context:[[NSString alloc] initWithString:textField.text]];	
}

-(void) processGeoDatAsync:(NSDictionary*)data 
{	
    QBGeoData *answerGeoData = [data objectForKey:GEODATA_KEY];
	CLLocation *location = [[SSLocationDataSource sharedDataSource] getCurrentLocation];
		
	NSManagedObjectContext * context = [StorageProvider threadSafeContext];
	NSError *error = nil;
	Users *user = nil;
	BOOL hasChanges = NO;
	
	if(answerGeoData)
	{
		int userID = answerGeoData.user.ID;
		user = [[UsersProvider sharedProvider] userByUID:[NSNumber numberWithInt:userID] context:context];
		
		if(nil == user)
		{
			QBUser* serverUser = [QBUser GetUser:userID].user;
			NSString *userName = nil;
			if (serverUser) 
			{
				userName = serverUser.name;
			}
			
			user = [[UsersProvider sharedProvider] addUserWithUID:[NSNumber numberWithInt:userID] 
															 name:userName 
														 location:location 
														  context:context];
			hasChanges = YES;
		}
	}
	
	NSString *msg = [NSString stringWithFormat:@"%@",[data objectForKey:MESSAGE_KEY]];	
	NSString* Id = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
	Messages* message= [[ChatListProvider sharedProvider] addMessageWithUID:Id 
																	   text:msg 
																   location:[NSString stringWithFormat:@"%@", location] 
																	context:context];
    message.user= user;
		
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
	hasChanges &= [context save:&error];
	[nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
	if(hasChanges)
	{
		[nc postNotificationName:nRefreshAnnotationDetails object:nil userInfo:nil];			
	}
	
	[chatDataSource performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)mergeChanges:(NSNotification *)notification
{	
	NSManagedObjectContext * sharedContext = [StorageProvider sharedInstance].managedObjectContext;
	NSManagedObjectContext * currentContext = (NSManagedObjectContext *)[notification object];
	if ( currentContext == sharedContext) 
	{		
		[currentContext performSelector:@selector(mergeChangesFromContextDidSaveNotification:) 
							   onThread:[NSThread currentThread] 
							 withObject:notification 
						  waitUntilDone:NO];		
	}
	else 
	{
		[sharedContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
										withObject:notification 
									 waitUntilDone:YES];	
	}
}

#pragma mark -
#pragma mark ActionStatusDelegate

- (void)completedWithResult:(Result*)result
{
	[self completedWithResult:result context:nil];
}

- (void)completedWithResult:(Result*)result context:(void*)contextInfo
{
	NSString *message = (NSString*)contextInfo;
	
	if(result.success)
	{
		if([result isKindOfClass:[QBGeoDataResult class]])
		{
			QBGeoDataResult *geoDataRes = (QBGeoDataResult*)result; 
			NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:message, MESSAGE_KEY, geoDataRes.geoData, GEODATA_KEY, nil]; 
			[self performSelectorInBackground:@selector(processGeoDatAsync:) withObject:data];
		}
	}
	else 
	{
		[self performSelectorInBackground:@selector(processGeoDatAsync:) withObject:[NSDictionary dictionaryWithObject:message forKey:MESSAGE_KEY]];
	}
	
	[message release];
}

#pragma mark -

-(void)dismissKeyboard {
    [textField resignFirstResponder];
}

-(void) dealloc{
    self.privateChatController=nil;
    [chatDataSource release];
    [textField release];
    [tabView release];
    [super dealloc];

}
@end
