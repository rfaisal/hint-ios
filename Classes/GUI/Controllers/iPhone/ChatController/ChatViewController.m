//
//  ChatViewController.m
//  SuperSample
//
//  Created by Andrey Kozlov on 8/23/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "ChatViewController.h"

//Data
#import "Messages.h"
#import "UsersProvider.h"
#import "ChatListProvider.h"
#import "StorageProvider.h"
#import "Users.h"

#import "SourceImages.h"


@implementation ChatViewController
@synthesize chatDataSource;
@synthesize tabView;
@synthesize textField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)subscribe{
    [super subscribe];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refreshChat:) 
                                                 name:nRefreshChat object:nil];
}

-(void)unsubscribe{
    [super unsubscribe];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nRefreshChat object:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];
    [FlurryAPI logEvent:@"ChatViewController, viewDidLoad"];
    
    [chatDataSource reloadData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.tabView addGestureRecognizer:tap];
    [tap release];
    
    // progress wheel
    wheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    wheel.center =  CGPointMake(textField.frame.size.width - 16, textField.center.y-7);
    [textField addSubview:wheel];
    [wheel release];
}

- (void)viewDidUnload{
    [self setTextField:nil];
    [self setChatDataSource:nil];
    [self setTabView:nil];
    
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // retrieve messages
    [self retrieveMessages:nil];
    
    // retrieve mesages every kUpdateChatInterval seconds
    [self strartRetrieveNewMessages];
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [updateGeoDataTimer invalidate];
    updateGeoDataTimer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Retrieve new messages
- (void) retrieveMessages:(NSTimer *) timer{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // create QBLGeoDataSearchRequest entity
	QBLGeoDataGetRequest *searchRequest = [[QBLGeoDataGetRequest alloc] init];
	searchRequest.status = YES;// only with status
    searchRequest.sortBy = GeoDataSortByKindCreatedAt;
    searchRequest.perPage = 15; // last 15 messages
    
    // retrieve messages
	[QBLocation geoDataWithRequest:searchRequest delegate:self];
	[searchRequest release];
}

// Start retrieve new messages
-(void) strartRetrieveNewMessages{
    
    // retrieve mesages every kUpdateChatInterval seconds
	updateGeoDataTimer = [NSTimer scheduledTimerWithTimeInterval:kUpdateChatInterval
                                                          target:self
                                                        selector:@selector(retrieveMessages:)
                                                        userInfo:nil
                                                         repeats:YES];
}

// Send new message
-(IBAction) sendAction:(id)sender{
    
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return;
    }    
    
    Users *user = [[UsersProvider sharedProvider] currentUser];
    if(user == nil){
        [self showMessage:NSLocalizedString(@"You must first be authorized. Go to Settings tab", "") message:nil delegate:nil];
        return;
    }

    // create QBLGeoData entity
	QBLGeoData *geoData = [QBLGeoData currentGeoData];
	geoData.user = user.qbUser;
    geoData.status = textField.text;

    // create message
	[QBLocation createGeoData:geoData delegate:self];	
    
    [wheel startAnimating];
}

// process single message
-(void) processMessage:(QBLGeoData *)data {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	CLLocation *location =  [[QBLLocationDataSource instance] currentLocation];
		
	NSManagedObjectContext *context = [StorageProvider threadSafeContext];
	NSError *error = nil;
	BOOL hasChanges = NO;
	NSString *chatMessage = [NSString stringWithFormat:@"%@", data.status];	
	NSString *ID = [NSString stringWithFormat:@"%u", data.ID];
    
    // get & update user
    Users *currentUser = [[UsersProvider sharedProvider] currentUserWithContext:context];
    currentUser.status = chatMessage;
    [[UsersProvider sharedProvider] saveUserWithContext:context];
    
    // save message
	[[ChatListProvider sharedProvider] addMessageWithUID:ID 
                                                    text:chatMessage 
                                                location:[NSString stringWithFormat:@"%@", location] 
                                                    user:currentUser
                                                    date:data.createdAt
                                                 context:context];
		
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
    
    // update own status
    [nc postNotificationName:nChangedOwnStatus object:nil userInfo:nil];	
    
	[nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
	hasChanges = [context save:&error];
	[nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
	if(hasChanges){
		[nc postNotificationName:nRefreshChat object:nil userInfo:nil];	
	}
    
    [pool drain];
}

// process array of messages
-(void) processMessages:(NSArray *)geodata{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	NSManagedObjectContext *context = [StorageProvider threadSafeContext];
	NSError *error = nil;
	
    BOOL hasChanges = NO;
    
	for (QBLGeoData *geoData in geodata) {
        NSString *msg = [NSString stringWithFormat:@"%@", geoData.status];	
        NSString *Id = [NSString stringWithFormat:@"%u", geoData.ID];
        
        // message already exist
        if([[ChatListProvider sharedProvider] messageByUID:[NSNumber numberWithUnsignedInteger:geoData.ID] context:context]){
            continue;
        }
        if([[ChatListProvider sharedProvider] messageByUser:geoData.user.ID message:msg context:context]){
            continue;
        }
        
        
        // create if not exist
        Users *user = [[UsersProvider sharedProvider] userByUID:[NSNumber numberWithUnsignedInteger:geoData.user.ID] context:context];
        if(user == nil){
            user = [[UsersProvider sharedProvider] addUser:geoData.user location:[geoData location] status:geoData.status context:context];
        }
        
        
        // create 
        [[ChatListProvider sharedProvider] addMessageWithUID:Id 
                                                        text:msg 
                                                    location:[NSString stringWithFormat:@"%@", [geoData location]] 
                                                        user:user
                                                        date:geoData.createdAt
                                                     context:context];
        

        hasChanges = YES;
	}
	
	if(hasChanges){
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
		[nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
        
		hasChanges = [context save:&error];
		
        [nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
        
		if(hasChanges){
			[nc postNotificationName:nRefreshChat object:nil userInfo:nil];			
		}	
	}
    
     [pool drain];
}

- (void)mergeChanges:(NSNotification *)notification{	
	NSManagedObjectContext * sharedContext = [StorageProvider sharedInstance].managedObjectContext;
	NSManagedObjectContext * currentContext = (NSManagedObjectContext *)[notification object];
	if(currentContext == sharedContext){		
		[currentContext performSelector:@selector(mergeChangesFromContextDidSaveNotification:) 
							   onThread:[NSThread currentThread] 
							 withObject:notification 
						  waitUntilDone:NO];		
	}else {
		[sharedContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
										withObject:notification 
									 waitUntilDone:YES];	
	}
}


#pragma mark -
#pragma mark Notifications

// refresh Chat
-(void)refreshChat:(NSNotification *)notification{
	[chatDataSource performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result*)result{
    
    // create new message result
    if([result isKindOfClass:[QBLGeoDataResult class]]){
        
        // Success result
        if(result.success){
            
            // process message
            QBLGeoDataResult *geoDataRes = (QBLGeoDataResult*)result; 
            [self performSelectorInBackground:@selector(processMessage:) withObject:geoDataRes.geoData];
            textField.text = @"";
        }
        [wheel stopAnimating];
        
    // retrieve new messages result
    }else if([result isKindOfClass:[QBLGeoDataPagedResult class]]){
        
        // Success result
        if(result.success){
            
            // process messagees
            QBLGeoDataPagedResult *geoDataSearchRes = (QBLGeoDataPagedResult *)result;
            [self performSelectorInBackground:@selector(processMessages:) withObject:geoDataSearchRes.geodata];
        }
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    [_textField resignFirstResponder];
    [self sendAction:_textField];
    return YES;
}


#pragma mark -

-(void)dismissKeyboard {
    [textField resignFirstResponder];
}

-(void) dealloc{
    [chatDataSource release];
    [textField release];
    [tabView release];
    [super dealloc];
}

@end