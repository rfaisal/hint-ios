//
//  ChatEngine.m
//  
//


//
#import "ChatEngine.h"

//Models
#import "ChatEntry.h"
#import "UserModel.h"
#import "ChatMessageModel.h"

//Data
#import "PrivateChatListProvider.h"
#import "PrivateMessages.h"
#import "UsersProvider.h"
#import "Users.h"

//Helpers
#import "GDConnectionHelper.h"

@interface ChatEngine (Private)

- (void) loadHistory;
- (void) saveHistoryFor;
- (void) removeHistory:(NSString*)userID;
- (void) updateConversationOrder;

- (void) messageArrived:(NSNotification*)notification;
- (void) showConversationView:(NSNotification*)notification;

@end



@implementation ChatEngine

@synthesize delegate;
@synthesize chatsHistory;
@synthesize currentConversations;
@synthesize currentConversationsOrder;
@synthesize currentChat;
@synthesize newMessagesCount;


#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	//[[NSNotificationCenter defaultCenter] removeObserver:self name:nMessageArrived object:nil];
	[self removeObserver:self forKeyPath:@"currentChat"];
	
	[delegate release];
	[chatsHistory release];
	[currentConversations release];
	[currentConversationsOrder release];
	[currentChat release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Init

+ (ChatEngine*) sharedEngine {
	static id instance = nil;
	
	@synchronized (self) {
		if (instance == nil) instance = [[ChatEngine alloc] init];
	}
	
	return instance;
}

- (id) init {
	if ((self = [super init])) {
		self.chatsHistory = [NSMutableDictionary dictionaryWithCapacity:0];
		self.currentConversations = [NSMutableDictionary dictionaryWithCapacity:0];
		self.currentConversationsOrder = [NSMutableArray arrayWithCapacity:0];
		
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageArrived:) name:nMessageArrived object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showConversationView:) name:nShowConversationView object:nil];
		
		[self addObserver:self forKeyPath:@"currentChat" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
		
        NSLog(@"[self loadHistory]");
//		[self loadHistory];
	}
	return self;
	}

- (void)clearHistory {
    self.chatsHistory = [NSMutableDictionary dictionaryWithCapacity:0];
	self.currentConversations = [NSMutableDictionary dictionaryWithCapacity:0];
	self.currentConversationsOrder = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark -
#pragma mark Private Methods

- (void) loadHistory 
{
    Users* user = [[UsersProvider sharedProvider] currentUser];
    
	if (user.mbUser) 
    {
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *historyPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/History/conversations.plist", user.mbUser.ID]];
//		NSLog(@"%@",[NSString stringWithContentsOfFile:historyPath]);
		NSMutableDictionary *savedDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:historyPath];
		
		if (savedDictionary != nil) {
			self.chatsHistory = [NSMutableDictionary dictionaryWithCapacity:0];
			self.currentConversations = [NSMutableDictionary dictionaryWithCapacity:0];
			
			NSMutableArray *keys = [NSMutableArray arrayWithArray:[savedDictionary allKeys]];
			
			[keys sortUsingSelector:@selector(compare:)];
			
			for (NSString* key in keys) {
				if ([[savedDictionary objectForKey:key] objectForKey:@"user"]) {
					ChatEntry *entry = [[[ChatEntry alloc] init] autorelease];
					entry.oponent = [[savedDictionary objectForKey:key] objectForKey:@"user"];
					entry.userWith = [[[UserModel alloc] initWithUserID:entry.oponent thumbnailURL:nil] autorelease];
					
					[self.chatsHistory setObject:entry forKey:key];
					[self.currentConversations setObject:entry forKey:key];
					
//					GetUserProfileQuery *query = [[[GetUserProfileQuery alloc] initWithUserID:entry.oponent vieverID:[CurrentUser curentUser].mbUser.ID filterRated:NO language:[Settings currentLanguageCode]] autorelease];
//					[query performAsyncWithDelegate:self context:[entry retain]];
				
					[entry loadHistory];
				}
			}
		}
		
		historyPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/History/conversationsOrder.plist", user.mbUser.ID]];
		
		NSMutableArray *keys = [NSMutableArray arrayWithContentsOfFile:historyPath];
		if (keys != nil) 
		{
			self.currentConversationsOrder = [NSMutableArray arrayWithCapacity:0];
			
			for (NSString* key in keys) 
			{
				ChatEntry *entry = [self.chatsHistory objectForKey:key];
				if (entry)
					[self.currentConversationsOrder addObject:entry];
			}
			
			[self updateConversationOrder];
		} 
		else 
		{
			NSMutableArray *keys = [NSMutableArray arrayWithArray:[savedDictionary allKeys]];
			
			[keys sortUsingSelector:@selector(compare:)];
			
			for (NSString* key in keys) 
			{
				ChatEntry *entry = [self.chatsHistory objectForKey:key];
				
				if (entry)
					[self.currentConversationsOrder addObject:entry];
			}
			
			[self updateConversationOrder];
		}
	}
}

- (void) saveHistory 
{
    Users* user = [[UsersProvider sharedProvider] currentUser];
    
	if (user.mbUser) 
	{
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
			
		NSError *error = [[[NSError alloc] init] autorelease];
        
		[[NSFileManager defaultManager] createDirectoryAtPath:[docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", user.mbUser.ID]] 
								  withIntermediateDirectories:NO attributes:nil error:&error];
		[[NSFileManager defaultManager] createDirectoryAtPath:[docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/History", user.mbUser.ID]] 
								  withIntermediateDirectories:NO attributes:nil error:&error];
				
		NSMutableArray *keys = [NSMutableArray arrayWithArray:[self.chatsHistory allKeys]];
		
		[keys sortUsingSelector:@selector(compare:)];
		
		/*for (NSString* key in keys) 
		{
			ChatEntry *entry = [self.chatsHistory objectForKey:key];
			if ([self.currentChat.oponent isEqualToString:entry.oponent]) 
			{
				[entry saveHistory];
			}			
		}*/
		
		NSString *historyPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/History/conversationsOrder.plist", user.mbUser.ID]];
		NSMutableArray *conversationOrders = [NSMutableArray arrayWithContentsOfFile:historyPath];
		if (![conversationOrders containsObject:self.currentChat.oponent]) 
		{
			[self updateConversationOrder];
		}
	}
}

- (void) removeHistory:(NSString*)userID
{
    Users* user = [[UsersProvider sharedProvider] currentUser];
    
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];	
	NSString *historyPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/History/%@", user.mbUser.ID, userID]];
	if([[NSFileManager defaultManager] fileExistsAtPath:historyPath])
	{
		[[NSFileManager defaultManager] removeItemAtPath:historyPath error:nil];
	}	
		
	historyPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/History/conversations.plist", user.mbUser.ID]];
	NSMutableDictionary *savedConversations = [NSMutableDictionary dictionaryWithContentsOfFile:historyPath];
	[savedConversations removeObjectForKey:userID];
	[savedConversations writeToFile:historyPath atomically:YES];
	
	historyPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/History/conversationsOrder.plist", user.mbUser.ID]];
	NSMutableArray *conversationOrders = [NSMutableArray arrayWithContentsOfFile:historyPath];
	[conversationOrders removeObject:userID];	
	[conversationOrders writeToFile:historyPath atomically:YES];
}

- (void) updateConversationOrder
{
    
}

- (NSUInteger)newMessageCountForUser:(NSString*)userID {
	ChatEntry *chat = [self.currentConversations objectForKey:userID];
	
	if (chat == nil) {
		if ([self.chatsHistory objectForKey:userID] != nil) {
			chat = [self.chatsHistory objectForKey:userID];
			
		} else {
			return 0;
		}
	}
	
	return chat.newMessageCount;
}

#pragma mark -
#pragma mark Notifications

- (void) messageArrived:(NSDictionary*)notification 
{
    NSLog(@"notification: %@",notification);
    
	NSString *from = [notification objectForKey:@"from"];
    from = [[from componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSString *to = [notification objectForKey:@"to"];
    to = [[to componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSString* messageText = ((ChatMessageModel*)[notification objectForKey:@"message"]).text;
    NSString* Id = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    PrivateMessages* message = [[PrivateChatListProvider sharedProvider] addMessageWithUID:Id text:messageText location:nil];
    message.userFrom=[NSNumber numberWithInt: [from integerValue]];
    message.userTo=[NSNumber numberWithInt: [to integerValue]];
    
    if(message.userFrom==nil || message.userTo==nil)
        NSLog(@"Invalid user id in arrived message");
        
    [[NSNotificationCenter defaultCenter] postNotificationName:nMessageArrived object:nil];
//    NSLog(@"messageArrived: %@ from: %@ to: ",messageText, userName);
	
//	if (userName == nil && self.currentChat != nil) 
//	{
//		if (([self.currentChat.pagedHistory count] == 0) || [[NSDate date] timeIntervalSinceDate: ((ChatMessageModel*)[self.currentChat.pagedHistory lastObject]).messageDate] > 300) {
//			[self.currentChat addMessage:[[[ChatMessageModel alloc] initWithType:YES typeMessage:ChatMessageStartDate text:@"" file:nil location:nil date:nil] autorelease]];
//			
//			if (self.currentChat != nil) 
//			{
//				//[[NSNotificationCenter defaultCenter] postNotificationName:nShowNewMessage object:nil];
//				[delegate refreshConversation];
//			}
//		}
//		
//		//Are we realy need this code?
//		if (![self.currentConversationsOrder containsObject:self.currentChat]) 
//		{
//			[self.chatsHistory setObject:self.currentChat forKey:self.currentChat.oponent];
//			[self.currentConversations setObject:self.currentChat forKey:self.currentChat.oponent];
//			[self.currentConversationsOrder insertObject:self.currentChat atIndex:0];
//			[self updateConversationOrder];
//		}
//		
//		[self.currentChat addMessage:[notification objectForKey:@"message"]];
//		[self saveHistory];
//		//[[NSNotificationCenter defaultCenter] postNotificationName:nShowNewMessage object:nil];
//		[delegate refreshConversation];
//		return;
//	}
//	
//	[[NSNotificationCenter defaultCenter] postNotificationName:nMessageArrived object:nil];
//	
//	userName = [[userName componentsSeparatedByString:@"@"] objectAtIndex:0];
//	
//	ChatEntry *chat = [self.currentConversations objectForKey:userName];
//	
//	if (chat == nil) 
//	{
//		if ([self.chatsHistory objectForKey:userName] != nil) 
//		{
//			chat = [self.chatsHistory objectForKey:userName];
//			chat.oponent = userName;
//			[chat addObserver:self forKeyPath:@"newMessageCount" options:NSKeyValueObservingOptionNew context:nil];
//			
//			[self.currentConversations setObject:chat forKey:userName];
//			
////			GetUserProfileQuery *query = [[[GetUserProfileQuery alloc] initWithUserID:chat.userWith.userID vieverID:[CurrentUser curentUser].mbUser.ID filterRated:NO language:[Settings currentLanguageCode]] autorelease];
////			[query performAsyncWithDelegate:self context:[chat retain]];
//			
//			if (((ChatMessageModel*)[notification objectForKey:@"message"]).messageDate == nil) 
//			{
//				[chat addMessage:[[[ChatMessageModel alloc] initWithType:YES typeMessage:ChatMessageStartDate text:@"" file:nil location:nil date:nil] autorelease]];
//			} 
//			else 
//			{
//				[chat addMessage:[[[ChatMessageModel alloc] initWithType:YES typeMessage:ChatMessageStartDate text:@"" file:nil location:nil date:((ChatMessageModel*)[notification objectForKey:@"message"]).messageDate] autorelease]];
//			}
//		} 
//		else 
//		{
//			chat = [[[ChatEntry alloc] init] autorelease];
//			chat.oponent = userName;
//			[chat addObserver:self forKeyPath:@"newMessageCount" options:NSKeyValueObservingOptionNew context:nil];
//			
//			chat.userWith = [[[UserModel alloc] initWithUserID:userName thumbnailURL:@""] autorelease];
//			
////			GetUserProfileQuery *query = [[[GetUserProfileQuery alloc] initWithUserID:userName vieverID:[CurrentUser curentUser].mbUser.ID filterRated:NO language:[Settings currentLanguageCode]] autorelease];
////			[query performAsyncWithDelegate:self context:[chat retain]];
//			
//			
//			[self.chatsHistory setObject:chat forKey:userName];
//			[self.currentConversations setObject:chat forKey:userName];
//			
//			if (((ChatMessageModel*)[notification objectForKey:@"message"]).messageDate == nil) 
//			{
//				[chat addMessage:[[[ChatMessageModel alloc] initWithType:YES typeMessage:ChatMessageStartDate text:@"" file:nil location:nil date:nil] autorelease]];
//			} 
//			else 
//			{
//				[chat addMessage:[[[ChatMessageModel alloc] initWithType:YES typeMessage:ChatMessageStartDate text:@"" file:nil location:nil date:((ChatMessageModel*)[notification objectForKey:@"message"]).messageDate] autorelease]];
//			}
//		}
//	} 
//	else 
//	{
//        [chat addObserver:self forKeyPath:@"newMessageCount" options:NSKeyValueObservingOptionNew context:nil];
//    }
//	
//	if ([self.currentConversationsOrder containsObject:chat]) 
//	{
//		[self.currentConversationsOrder removeObject:chat];
//		[self.currentConversationsOrder insertObject:chat atIndex:0];
//	} 
//	else 
//	{
//		[self.currentConversationsOrder insertObject:chat atIndex:0];
//	}
//NSLog(@"[self updateConversationOrder];");
//	[self updateConversationOrder];
//	
//	if (((ChatMessageModel*)[notification objectForKey:@"message"]).messageDate) {
//		if ([((ChatMessageModel*)[notification objectForKey:@"message"]).messageDate timeIntervalSinceDate:((ChatMessageModel*)[chat.pagedHistory lastObject]).messageDate] > 300) {
//			chat.openSession = NO;
//			[chat addMessage:[[[ChatMessageModel alloc] initWithType:YES typeMessage:ChatMessageStartDate text:@"" file:nil location:nil date:((ChatMessageModel*)[notification objectForKey:@"message"]).messageDate] autorelease]];
//			
//			if (self.currentChat != nil) {
//				//[[NSNotificationCenter defaultCenter] postNotificationName:nShowNewMessage object:nil];
//				[delegate refreshConversation];
//			}
//		}
//	} else {
//		if ([[NSDate date] timeIntervalSinceDate:((ChatMessageModel*)[chat.pagedHistory lastObject]).messageDate] > 300) {
//			chat.openSession = NO;
//			[chat addMessage:[[[ChatMessageModel alloc] initWithType:YES typeMessage:ChatMessageStartDate text:@"" file:nil location:nil date:nil] autorelease]];
//			
//			if (self.currentChat != nil) {
//				//[[NSNotificationCenter defaultCenter] postNotificationName:nShowNewMessage object:nil];
//				[delegate refreshConversation];
//			}
//		}
//	}
//
//	[chat addMessage:[notification objectForKey:@"message"]];
//    NSLog(@"[self saveHistory];");
////    [self saveHistory];
//
//	if (self.currentChat != chat || [GDConnectionHelper instance].inactive || [GDConnectionHelper instance].inBackground)
//	  chat.newMessageCount += 1;
//	
//	[[NSNotificationCenter defaultCenter] postNotificationName:nMessageArrived object:nil];
//		
//	if (![GDConnectionHelper instance].inactive && self.currentChat != chat)
//		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//	
//	if (self.currentChat == nil) {
//		//self.currentChat = chat;
//		//[delegate openConversationWith:chat];
//		
//	} else {		
//		//[[NSNotificationCenter defaultCenter] postNotificationName:nShowNewMessage object:nil];
//		[delegate refreshConversation];
//	}
}
- (NSInteger)allNewMessages {
	NSInteger sum = 0;
	NSArray* vals = [chatsHistory allValues];
	for (ChatEntry* entry in vals)
	{
		NSInteger msg = entry.newMessageCount;
		if(msg>0)
			sum += msg;
	}
	return sum;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	if([@"newMessageCount" isEqualToString:keyPath])
	{
		if(((ChatEntry*)object).newMessageCount<0)
			[object removeObserver:self forKeyPath:@"newMessageCount"];
		else 
			self.newMessagesCount = [self allNewMessages];
		
		[self.delegate setNewMessagesValue:self.newMessagesCount];
		[[NSNotificationCenter defaultCenter] postNotificationName:nMessageArrived object:nil];
	} else if ([@"currentChat" isEqualToString:keyPath]) {
		if ([[change objectForKey:NSKeyValueChangeOldKey] isKindOfClass:[NSNull class]] && self.currentChat != nil) {
			self.currentChat.newMessageCount = 0;
			[[NSNotificationCenter defaultCenter] postNotificationName:nMessageArrived object:nil];
		}
	}
	else if([super respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)])
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:nil];
}
- (void) showConversationView:(NSNotification*)notification {
	NSString *userName = ((UserModel*)[[notification userInfo] objectForKey:kUserModelInstanceKey]).userID;
	
	[self showConversationViewForUser:userName userModel:((UserModel*)[[notification userInfo] objectForKey:kUserModelInstanceKey])];
}

- (ChatEntry*)showConversationViewForUser:(NSString*)userID userModel:(UserModel*)user {
	ChatEntry *chat = [self.currentConversations objectForKey:userID];
	
	if (chat == nil) {
		/*if ([self.chatsHistory objectForKey:userName] != nil) {
		 chat = [self.chatsHistory objectForKey:userName];
		 chat.oponent = userName;
		 chat.userWith = ((UserModel*)[[notification userInfo] objectForKey:kUserModelInstanceKey]);
		 [self.currentConversations setObject:chat forKey:userName];
		 chat.openSession = YES;
		 } else {*/
		chat = [[[ChatEntry alloc] init] autorelease];
		chat.oponent = userID;
		chat.userWith = user;

//		[FlurryEngine logOpenNewConversationEvent];

		if (user == nil) {
			chat.userWith = [[[UserModel alloc] initWithUserID:userID thumbnailURL:@""] autorelease];
			
//			GetUserProfileQuery *query = [[[GetUserProfileQuery alloc] initWithUserID:userID vieverID:[CurrentUser curentUser].mbUser.ID filterRated:NO language:[Settings currentLanguageCode]] autorelease];
//			[query performAsyncWithDelegate:self context:[chat retain]];
		}
		
		chat.openSession = YES;
		
		//[self.chatsHistory setObject:chat forKey:userName];
		//[self.currentConversations setObject:chat forKey:userName];
		//[self saveHistory];
		//}
	} 
	
	if ([self.currentConversationsOrder containsObject:chat]) 	
	{
		[self.currentConversationsOrder removeObject:chat];
		[self.currentConversationsOrder insertObject:chat atIndex:0];		
	} 
	else if ([self.chatsHistory objectForKey:userID])
	{
		[self.currentConversationsOrder insertObject:chat atIndex:0];		
	}
	
	[self updateConversationOrder];
	self.currentChat = chat;
	
	[delegate openConversationWith:chat];

	return chat;
}
- (void)showChatView {
	[delegate openConversations];
}

- (NSArray*) chats {
	//NSMutableArray *chatsArray = [NSMutableArray arrayWithCapacity:0];
	
	//NSMutableArray *keys = [NSMutableArray arrayWithArray:[self.currentConversations allKeys]];
	
	//[keys sortUsingSelector:@selector(compare:)];
	
	//for (NSString* key in keys) 
	//	[chatsArray addObject:[self.currentConversations objectForKey:key]];
	
	//NSMutableArray *values = [NSMutableArray arrayWithArray:[self.currentConversations allValues]];

	//NSSortDescriptor *discriptor = [NSSortDescriptor sortDescriptorWithKey:@"newMessageCount" ascending:NO];
	
	//[values sortUsingDescriptors:[NSArray arrayWithObject:discriptor]];
	 
	return [NSArray arrayWithArray:self.currentConversationsOrder];
}

#pragma mark -
#pragma mark ActionStatusDelegate

- (void) completedWithResult:(Result*)result{
	[self completedWithResult:result context:nil];
}
- (void) completedWithResult:(Result*)result context:(void*)context {
	ChatEntry *chat = (ChatEntry*)context;
	
	if (chat != nil && [chat isKindOfClass:[ChatEntry class]]) {
//		GetUserProfileResult *res = (GetUserProfileResult*)result;
//		chat.userWith = res.userProfile;
	}
}

#pragma mark -
#pragma mark Alert View delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}

@end
