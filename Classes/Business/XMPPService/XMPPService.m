//
//  XMPPService.m

//



//XMPP
#import "XMPPService.h"
#import "XMPP.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPRoster.h"

//Model
#import "UsersProvider.h"
#import "Users.h"
#import "SendMessageModel.h"
#import "ChatMessageModel.h"
#import "FileModel.h"

//Engine
#import "ChatEngine.h"

//Data sources
#import "SSLocationDataSource.h"

//Helpers
#import "Converter.h"
#import "GDConnectionHelper.h"

@implementation XMPPService

@synthesize shouldConnect;
@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize isOpen;

- (void)dealloc {
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppStream disconnect];
	[xmppStream release];
	[xmppRoster release];
	[messageQueue release];
	
	[super dealloc];
}

+ (XMPPService*) sharedService {
	static id instance = nil;
	
	@synchronized (self) {
		if (instance == nil) instance = [[XMPPService alloc] init];
	}
	
	return instance;
}

- (id) init {
	if ((self = [super init])) {
		
		xmppStream = [[XMPPStream alloc] init];
		xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
		xmppRoster = [[XMPPRoster alloc] initWithStream:xmppStream rosterStorage:xmppRosterStorage];
		
		[xmppStream addDelegate:self];
		[xmppRoster addDelegate:self];
		
		[xmppRoster setAutoRoster:YES];
		
		// Replace me with the proper domain and port.
		// The example below is setup for a typical google talk account.
#ifdef GTalk
		[xmppStream setHostName:@"talk.google.com"];
#else
		[xmppStream setHostName:@"jabber.qsoft.mob1serv.com"];
#endif
		[xmppStream setHostPort:5222];
		
		// You may need to alter these settings depending on the server you're connecting to
		allowSelfSignedCertificates = NO;
		allowSSLHostNameMismatch = NO;
		messageQueue = [[NSOperationQueue alloc] init];
		[messageQueue setMaxConcurrentOperationCount:1];
        isRegistrInProgress = NO;
	}
	return self;
}

- (void) connect 
{
	isRegistrInProgress = NO;
	
    Users* user = [[UsersProvider sharedProvider] currentUser];
    
	// Replace me with the proper JID and password
#ifdef GTalk
	[xmppStream setMyJID:[XMPPJID jidWithString:@"kozlov.andreyv@gmail.com/SuperSampleApp"]];
	password = @"";
#else
	[xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:emailForConnect, user.mbUser.ID]]];
	password = commonPassword;
#endif
    NSLog(@"jid: %@",[NSString stringWithFormat:emailForConnect, user.mbUser.ID]);
	xmppStream.shouldConnect = shouldConnect;
	NSError *error = nil;
	if (![[self xmppStream] connect:&error])
	{
		NSLog(@"Error connecting: %@", error);
	}		
}

- (void) disconnect {
	[[self xmppStream] disconnect];
}

- (void) goOnline {
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	
	[[self xmppStream] sendElement:presence];
}
- (void) goOffline {
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	[presence addAttributeWithName:@"type" stringValue:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

- (void) registrUser {
	NSXMLElement *registr = [NSXMLElement elementWithName:@"iq"];
	[registr addAttributeWithName:@"type" stringValue:@"set"];
	
	NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
	[query addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:register"];
	
	[registr addChild:query];

    Users* user = [[UsersProvider sharedProvider] currentUser];
	[query addChild:[NSXMLElement elementWithName:@"username" stringValue:[NSString stringWithFormat:@"%i", user.mbUser.ID]]];
	[query addChild:[NSXMLElement elementWithName:@"password" stringValue:commonPassword]];
	[query addChild:[NSXMLElement elementWithName:@"email" stringValue:[NSString stringWithFormat:emailUserName, user.mbUser.ID]]];
	
	isRegistrInProgress = YES;
	NSLog(@"query: %@",[query children]);
    NSLog(@"registr: %@",registr);
	[[self xmppStream] sendElement:registr];
}

- (void) sendMessage:(SendMessageModel*)messageModel
{
	[self sendMessage:messageModel.messageText to:messageModel.to login:messageModel.login];
}

- (void) sendMessage:(NSString*)messageText to:(NSString*)to login:(NSString*)login 
{
	if (![xmppStream isAuthenticated]) 
	{
		NSError *error = nil;
		if (![xmppStream authenticateWithPassword:password error:&error])
		{
			NSLog(@"Error authenticating: %@", error);
			return;
		}
		
		SendMessageModel *messageModel = [[SendMessageModel alloc] initWithMessage:messageText to:to login:login];
		NSInvocationOperation *sendMsgOperation = [[NSInvocationOperation alloc] initWithTarget:self 
																					   selector:@selector(sendMessage:) 
																						 object:messageModel];
		[messageQueue setSuspended:YES];
		[messageQueue addOperation:sendMsgOperation];
		[messageModel release];
		[sendMsgOperation release];
		return;
	}
	
	BOOL first = YES;
	while ([messageText length] > 0) 
	{
		NSString *sendString = [messageText length] < MAXCountOfSymbols - 3 ? messageText : [messageText substringToIndex:MAXCountOfSymbols - 3];
		messageText = [messageText length] < MAXCountOfSymbols - 3 ? @"" : [messageText substringFromIndex:MAXCountOfSymbols - 3];
		
		if (!first)
			sendString = [NSString stringWithFormat:@"...%@", sendString];
		
		if ([messageText length] > 0)
			sendString = [NSString stringWithFormat:@"%@...", sendString];
	
	
		NSXMLElement *presence = [NSXMLElement elementWithName:@"message"];
		[presence addAttributeWithName:@"to" stringValue:to];
		
		NSXMLElement *info = [NSXMLElement elementWithName:@"info"];
		[info addAttributeWithName:@"from_login" stringValue:login];
		[presence addChild:info];
		
		NSXMLElement *message_b = [NSXMLElement elementWithName:@"body" stringValue:sendString];
		[presence addChild:message_b];
		
		[[self xmppStream] sendElement:presence];

//		[[ChatEngine sharedEngine] messageArrived:
//		 [NSDictionary dictionaryWithObjectsAndKeys:
//		  [[[ChatMessageModel alloc] initWithType:YES 
//									  typeMessage:ChatMessageTypeText
//											 text:sendString
//											 file:nil
//										 location:nil
//											 date:nil] autorelease], @"message", nil]];	
		
		first = NO;
	}
	
	NSString *toID = [[to componentsSeparatedByString:@"@"] objectAtIndex:0];
	
    if (login) {
	//for (int i = 0; i < 100; i++) {
		//NSLog(@"%d", i);
		
		QBNPushMessage *message = [[QBNPushMessage alloc] init];
		message.localizedBodyKey = @"CH_M";
		message.localizedBodyArguments = [NSArray arrayWithObject:login];//login nil crush
		message.localizedActionKey = @"View";
		message.soundFile = @"default";
		message.badge = [NSNumber numberWithInt:1];

        Users* user = [[UsersProvider sharedProvider] currentUser];
        
		message.additionalInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], nkMessageType, [NSNumber numberWithInt:user.mbUser.ID], nkUserID, [NSNumber numberWithInt:[toID intValue]], nkUserDestID, nil];
		
		//NSLog(@"%@", [message json]);
		
		[QBNotifierService TSendPush:message toExternalUser:[toID intValue] eventOwnerID:eventOwnerID delegate:nil];
	//}
    }
}
- (void) sendLocationTo:(NSString*)to login:(NSString*)login {
	if ([[SSLocationDataSource sharedDataSource] isLocationValid]) {
		NSXMLElement *presence = [NSXMLElement elementWithName:@"message"];
		[presence addAttributeWithName:@"to" stringValue:to];
		
		NSXMLElement *message_d = [NSXMLElement elementWithName:@"body" stringValue:@""];
		[presence addChild:message_d];
		
		NSXMLElement *info = [NSXMLElement elementWithName:@"info"];
		[info addAttributeWithName:@"from_login" stringValue:login];
		[presence addChild:info];
		
		NSXMLElement *message_b = [NSXMLElement elementWithName:@"location" stringValue:[NSString stringWithFormat:@"%f,%f", [[SSLocationDataSource sharedDataSource] getCurrentLocation].coordinate.latitude, [[SSLocationDataSource sharedDataSource] getCurrentLocation].coordinate.longitude]];
		[presence addChild:message_b];
		
		[[self xmppStream] sendElement:presence];
		
		[[ChatEngine sharedEngine] messageArrived:[NSDictionary dictionaryWithObjectsAndKeys:
		  [[[ChatMessageModel alloc] initWithType:YES 
									  typeMessage:ChatMessageTypeLocation
											 text:@"I'm here."
											 file:nil
										 location:[[SSLocationDataSource sharedDataSource] getCurrentLocation]
											 date:nil] autorelease], @"message", nil]];
		
		NSString *toID = [[to componentsSeparatedByString:@"@"] objectAtIndex:0];
		
        if (login) {
            QBNPushMessage *message = [[QBNPushMessage alloc] init];
            message.localizedBodyKey = @"CH_L";
            message.localizedBodyArguments = [NSArray arrayWithObject:login];
            message.localizedActionKey = @"View";
            message.soundFile = @"default";
            message.badge = [NSNumber numberWithInt:1];

            Users* user = [[UsersProvider sharedProvider] currentUser];
            
            message.additionalInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], nkMessageType, [NSNumber numberWithInt:user.mbUser.ID ], nkUserID, [NSNumber numberWithInt:[toID intValue]], nkUserDestID, nil];
            
            //NSLog(@"%@", [message json]);
            
            [QBNotifierService TSendPush:message toExternalUser:[toID intValue] eventOwnerID:eventOwnerID delegate:nil];
        }
	}
}

- (void) sendImage:(FileModel*)file to:(NSString*)to login:(NSString*)login {
	NSXMLElement *presence = [NSXMLElement elementWithName:@"message"];
	[presence addAttributeWithName:@"to" stringValue:to];
	
	NSXMLElement *message_d = [NSXMLElement elementWithName:@"body" stringValue:@""];
	[presence addChild:message_d];
	
	NSXMLElement *info = [NSXMLElement elementWithName:@"info"];
	[info addAttributeWithName:@"from_login" stringValue:login];
	[presence addChild:info];
	
	NSXMLElement *message_b = [NSXMLElement elementWithName:@"image"];
	[message_b addAttributeWithName:@"type" stringValue:file.type];
	[message_b addAttributeWithName:@"thumbnail" stringValue:file.urlThambneil];
	[message_b addAttributeWithName:@"url" stringValue:file.urlFile];
	
	[presence addChild:message_b];
	
	[[self xmppStream] sendElement:presence];
	
	[[ChatEngine sharedEngine] messageArrived:[NSDictionary dictionaryWithObjectsAndKeys:
	  [[[ChatMessageModel alloc] initWithType:YES 
								  typeMessage:ChatMessageTypeImage
										 text:@""
										 file:file
									 location:nil
										 date:nil] autorelease], @"message", nil]];
	
	NSString *toID = [[to componentsSeparatedByString:@"@"] objectAtIndex:0];
	
    if (login) {
        QBNPushMessage *message = [[QBNPushMessage alloc] init];
        message.localizedBodyKey = @"CH_P";
        message.localizedBodyArguments = [NSArray arrayWithObject:login];
        message.localizedActionKey = @"View";
        message.soundFile = @"default";
        message.badge = [NSNumber numberWithInt:1];

        Users* user = [[UsersProvider sharedProvider] currentUser];
        
        message.additionalInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], nkMessageType, [NSNumber numberWithInt:user.mbUser.ID], nkUserID, [NSNumber numberWithInt:[toID intValue]], nkUserDestID, nil];
        
        //NSLog(@"%@", [message json]);
        
        [QBNotifierService TSendPush:message toExternalUser:[toID intValue] eventOwnerID:eventOwnerID delegate:nil];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
	NSLog(@"---------- xmppStream:willSecureWithSettings: ----------");
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
	}
}
- (void) xmppStreamDidSecure:(XMPPStream *)sender {
	NSLog(@"---------- xmppStreamDidSecure: ----------");
}
- (void) xmppStreamDidConnect:(XMPPStream *)sender {
	NSLog(@"---------- xmppStreamDidConnect: ----------");
	
	isOpen = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		NSLog(@"Error authenticating: %@", error);
	}
}
- (void) xmppStreamDidAuthenticate:(XMPPStream *)sender {
	NSLog(@"---------- xmppStreamDidAuthenticate: ----------");
	
	[self goOnline];
	if ([messageQueue isSuspended]) 
	{
		[messageQueue setSuspended:NO];
	}
}
- (void) xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
	NSLog(@"---------- xmppStream:didNotAuthenticate: ----------");
	
	[self registrUser];
}
- (BOOL) xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
	NSLog(@"---------- xmppStream:didReceiveIQ: ----------");
	
	if (isRegistrInProgress) {
		[self disconnect];
		[self connect];
	}
	
	return YES;
}
- (void) xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
	NSLog(@"---------- xmppStream:didReceiveMessage: ----------");
	
	NSDate *delay = nil;
	
	if ([message elementForName:@"delay"] != nil) {
		delay = [Converter dateFromXMLString:[[[message elementForName:@"delay"] attributeForName:@"stamp"] stringValue]];
	}
	
	
	if ([message elementForName:@"body"] != nil && [[[message elementForName:@"body"] stringValue] length] > 0) {
		if ([[[message attributeForName:@"type"] stringValue] isEqualToString:@"error"]) {
			//[[[[BlackAlertView alloc] initWithTitle:[[message attributeForName:@"from"] stringValue] message:@"User is curently offline" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		} else {		
			if([GDConnectionHelper instance].inactive || [GDConnectionHelper instance].inBackground)
			{
				
				/*UILocalNotification* not = [[UILocalNotification alloc] init];
				//not.applicationIconBadgeNumber = 1;
				not.alertBody = [NSString stringWithFormat:NSLocalizedString(@"CH_M", @"%@ would like to chat to you. Tap View to start chatting"),[[[message elementForName:@"info"] attributeForName:@"from_login"] stringValue]];
				not.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[[message attributeForName:@"from"] stringValue], nkUserID, nil];
				not.alertAction = LS(@"View");
				not.soundName = UILocalNotificationDefaultSoundName;
				[[UIApplication sharedApplication] scheduleLocalNotification:not];
				[not release];*/
			}
			
			[[ChatEngine sharedEngine] messageArrived:[NSDictionary dictionaryWithObjectsAndKeys:
							[[[ChatMessageModel alloc] initWithType:NO 
														typeMessage:ChatMessageTypeText
															   text:[[message elementForName:@"body"] stringValue]
															   file:nil
														   location:nil
															   date:delay] autorelease], @"message", 
							[[message attributeForName:@"from"] stringValue], @"from",[[message attributeForName:@"to"] stringValue], @"to", nil]];
            
		}
	} else if ([message elementForName:@"location"] != nil) {
		if ([[[message attributeForName:@"type"] stringValue] isEqualToString:@"error"]) {
			//[[[[BlackAlertView alloc] initWithTitle:[[message attributeForName:@"from"] stringValue] message:@"User is curently offline" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		} else {		
			if([GDConnectionHelper instance].inactive || [GDConnectionHelper instance].inBackground)
			{
				/*UILocalNotification* not = [[UILocalNotification alloc] init];
				//not.applicationIconBadgeNumber = 1;
				not.alertBody = [NSString stringWithFormat:NSLocalizedString(@"CH_L", @"%@ profile name sent you his location - hurry, he might be close!"),[[[message elementForName:@"info"] attributeForName:@"from_login"] stringValue]];
				not.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[[message attributeForName:@"from"] stringValue], nkUserID, nil];
				not.alertAction = LS(@"View");
				not.soundName = UILocalNotificationDefaultSoundName;
				[[UIApplication sharedApplication] scheduleLocalNotification:not];
				[not release];*/
			}
				NSArray *locaCoord = [[[message elementForName:@"location"] stringValue] componentsSeparatedByString:@","];
				
				CLLocation *location = [[CLLocation alloc] initWithLatitude:[[locaCoord objectAtIndex:0] doubleValue] longitude:[[locaCoord objectAtIndex:1] doubleValue]];
				
				[[ChatEngine sharedEngine] messageArrived:[NSDictionary dictionaryWithObjectsAndKeys:
				  [[[ChatMessageModel alloc] initWithType:NO 
											  typeMessage:ChatMessageTypeLocation
													 text:@"I'm here."
													 file:nil
												 location:location
													 date:delay] autorelease], @"message", 
				  [[message attributeForName:@"from"] stringValue], @"from", nil]];
		}
	} else if ([message elementForName:@"image"] != nil) {
		if ([[[message attributeForName:@"type"] stringValue] isEqualToString:@"error"]) {
			//[[[[BlackAlertView alloc] initWithTitle:[[message attributeForName:@"from"] stringValue] message:@"User is curently offline" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		} else {		
			if([GDConnectionHelper instance].inactive || [GDConnectionHelper instance].inBackground)
			{
				/*UILocalNotification* not = [[UILocalNotification alloc] init];
				//not.applicationIconBadgeNumber = 1;
				not.alertBody = [NSString stringWithFormat:NSLocalizedString(@"CH_P", @"%@ profile name sent you his photo. Tap View to check him out."),[[[message elementForName:@"info"] attributeForName:@"from_login"] stringValue]];
				not.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[[message attributeForName:@"from"] stringValue], nkUserID, nil];
				not.alertAction = LS(@"View");
				not.soundName = UILocalNotificationDefaultSoundName;
				[[UIApplication sharedApplication] scheduleLocalNotification:not];
				[not release];*/
			}
			[[ChatEngine sharedEngine] messageArrived:[NSDictionary dictionaryWithObjectsAndKeys:
				  [[[ChatMessageModel alloc] initWithType:NO 
											  typeMessage:ChatMessageTypeImage
													 text:nil
													 file:[[[FileModel alloc] initWithType:[[[message elementForName:@"image"] attributeForName:@"type"] stringValue] thumbnail:[[[message elementForName:@"image"] attributeForName:@"thumbnail"] stringValue] file:[[[message elementForName:@"image"] attributeForName:@"url"] stringValue]] autorelease]
												 location:nil
													 date:delay] autorelease], @"message", 
				  [[message attributeForName:@"from"] stringValue], @"from", nil]];
		}
	}
}
- (void) xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
	NSLog(@"---------- xmppStream:didReceivePresence: ----------");
}
- (void) xmppStream:(XMPPStream *)sender didReceiveError:(id)error {
	NSLog(@"---------- xmppStream:didReceiveError: ----------");

}
- (void) xmppStreamDidDisconnect:(XMPPStream *)sender {
	NSLog(@"---------- xmppStreamDidDisconnect: ----------");
	
	[self connect];
	if (!isOpen)
	{
		NSLog(@"Unable to connect to server. Check xmppStream.hostName");
	}
}


@end
