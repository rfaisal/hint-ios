//
//  ChatEntry.m
//  
//


//

#import "ChatEntry.h"

//DataModels
#import "UserModel.h"
#import "ChatMessageModel.h"
#import "FileModel.h"

//Data
#import "UsersProvider.h"
#import "Users.h"

static int const kHistoryPageSize = 50;

@implementation ChatEntry

@synthesize oponent;
@synthesize userWith;
@synthesize pagedHistory;
@synthesize newMessageCount, initialPageIndex, lastPageIndex;
@synthesize openSession;

- (void) dealloc {
	self.newMessageCount = -3;
	[oponent release];
	[userWith release];
	[pagedHistory release];
	[self removeObserver:self forKeyPath:@"newMessageCount"];
	[super dealloc];
}

- (id) init {
	if (self = [super init]) {
		self.pagedHistory = [NSMutableArray arrayWithCapacity:0];
		[self addObserver:self forKeyPath:@"newMessageCount" options:NSKeyValueObservingOptionNew context:nil];
	}
	return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	if([@"newMessageCount" isEqualToString:keyPath])
	{
		//NSLog(@"nmc=%i",newMessageCount);
	}
}
- (void) addMessage:(ChatMessageModel*)message 
{
	if (message.my && [self.pagedHistory count] == 0) {
//		[FlurryEngine logStartChatConversationEvent:self.userWith.userID];		
	}
	[self.pagedHistory addObject:message];
	
    Users* user = [[UsersProvider sharedProvider] currentUser];
    
	if (message.my) 
    {
		[(ChatMessageModel*)[self.pagedHistory lastObject] setUserID:[NSString stringWithFormat:@"%i", user.mbUser.ID]];
	} else
		[(ChatMessageModel*)[self.pagedHistory lastObject] setUserID:self.userWith.userID];
	
	[[self.pagedHistory lastObject] refreshAttachment];
	if (((ChatMessageModel*)[self.pagedHistory lastObject]).messageDate == nil)
		[[self.pagedHistory lastObject] setMessageDate:[NSDate date]];
    NSLog(@"self saveHistory");
//    [self saveHistory];
}

- (void) saveHistory 
{
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	NSError *error = [[[NSError alloc] init] autorelease];
    
    Users* user = [[UsersProvider sharedProvider] currentUser];
    
	[[NSFileManager defaultManager] createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/History/%@", user.mbUser.ID, self.userWith.userID]] 
							  withIntermediateDirectories:NO attributes:nil error:&error];
		
	NSMutableArray *arrayForSave = [NSMutableArray arrayWithCapacity:0];
	
	for (ChatMessageModel *message in self.pagedHistory) 
	{
		if (message.messageType == ChatMessageTypeText)
            if (message.messageDate && message.text)
                [arrayForSave addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"text", @"type", message.text, @"text", message.my ? @"my" : @"other", @"my", message.messageDate, @"date", nil]];
		else if (message.messageType == ChatMessageTypeLocation)
			[arrayForSave addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"location", @"type", [NSString stringWithFormat:@"%f", message.location.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%f", message.location.coordinate.longitude], @"long", message.my ? @"my" : @"other", @"my", message.messageDate, @"date", nil]];
		else if (message.messageType == ChatMessageTypeImage)
			[arrayForSave addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image", @"type", message.file.type, @"fType", message.file.urlThambneil, @"thumb", message.file.urlFile, @"file", message.my ? @"my" : @"other", @"my", message.messageDate, @"date", nil]];
		else if (message.messageType == ChatMessageStartDate)
			[arrayForSave addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"date", @"type", message.messageDate, @"date", nil]];
	}
		
	NSNumber* lastPageNumber = [NSNumber numberWithInt:0];	
	NSString *historyConversationsPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/History/conversations.plist", user.mbUser.ID]];
	NSMutableDictionary *savedConversations = [NSMutableDictionary dictionaryWithContentsOfFile:historyConversationsPath];
	NSMutableDictionary *conversationsData = nil;
	if(savedConversations)
	{
		conversationsData = [savedConversations objectForKey:self.userWith.userID];
		if(!conversationsData)
		{			
			conversationsData = [NSDictionary dictionaryWithObjectsAndKeys:self.userWith.userID, @"user", lastPageNumber, @"lastPageNumber", nil];
			[savedConversations setObject:conversationsData forKey:self.userWith.userID];
			[savedConversations writeToFile:historyConversationsPath atomically:YES];
		}
	}
	else 
	{
		conversationsData = [NSDictionary dictionaryWithObjectsAndKeys:self.userWith.userID, @"user", lastPageNumber, @"lastPageNumber", nil];
		savedConversations = [NSMutableDictionary dictionaryWithObject:conversationsData forKey:self.userWith.userID];
		[savedConversations writeToFile:historyConversationsPath atomically:YES];
	}	

	int startPage = self.lastPageIndex - self.initialPageIndex;
	int number = (int)ceil((float)[arrayForSave count] / kHistoryPageSize);	
	int addedPages = 0;
	for (;startPage < number; startPage++, addedPages++) 
	{
		NSString *pageIndex = self.lastPageIndex + addedPages == 0 ? @"" : [NSString stringWithFormat:@"%i", self.lastPageIndex + addedPages];
		NSString *historyPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/History/%@/conversation%@.plist", user.mbUser.ID, self.userWith.userID, pageIndex]];
		NSArray *historyPages = [arrayForSave subarrayWithRange:NSMakeRange(startPage * kHistoryPageSize, MIN([arrayForSave count] - startPage * kHistoryPageSize, kHistoryPageSize))];
		[historyPages writeToFile:historyPath atomically:YES];
	}
	
	if (--addedPages > 0) 
	{
		self.lastPageIndex += addedPages;
		[conversationsData setObject:[NSNumber numberWithInt:self.lastPageIndex] forKey:@"lastPageNumber"];
		[savedConversations writeToFile:historyConversationsPath atomically:YES];		
	}	
}

- (void) loadHistory 
{	
    Users* user = [[UsersProvider sharedProvider] currentUser];
    
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *historyConversationsPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/History/conversations.plist", user.mbUser.ID]];
	NSMutableDictionary *savedConversations = [NSMutableDictionary dictionaryWithContentsOfFile:historyConversationsPath];
	NSMutableDictionary *oponentConversationsData = [savedConversations objectForKey:self.userWith.userID];
	NSNumber* lastPageNumber = nil;	
	self.lastPageIndex = 0;	
	if(oponentConversationsData)
	{
		lastPageNumber = [oponentConversationsData objectForKey:@"lastPageNumber"];
		if(lastPageNumber)
		{
			self.lastPageIndex = [lastPageNumber intValue];
		}		
	}
	
	self.pagedHistory = [self loadHistoryFromPage:0];
	self.initialPageIndex = self.lastPageIndex;
}

- (NSMutableArray*) loadHistoryFromPage:(NSInteger)page
{
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];		
	int lastPage = self.lastPageIndex;
	if(lastPage < page)
	{
		return nil;
	}
	else 
	{
		lastPage -= page;
	}

    Users* user = [[UsersProvider sharedProvider] currentUser];
    
	NSString *pageIndex = lastPage == 0 ? @"" : [NSString stringWithFormat:@"%i", lastPage];	
	NSString *historyPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/History/%@/conversation%@.plist", user.mbUser.ID, self.userWith.userID, pageIndex]];
	NSArray *arrayForSave = [NSMutableArray arrayWithContentsOfFile:historyPath];
	NSMutableArray *chatHistory = [NSMutableArray arrayWithCapacity:0];
	if (arrayForSave != nil) 
	{		
		for (NSDictionary *dic in arrayForSave) 
		{
			if ([@"text" isEqualToString:[dic objectForKey:@"type"]])
			{
				[chatHistory addObject:[[[ChatMessageModel alloc] initWithType:[@"my" isEqualToString:[dic objectForKey:@"my"]] 
																   typeMessage:ChatMessageTypeText 
																		  text:[dic objectForKey:@"text"]
																		  file:nil
																	  location:nil 
																		  date:nil] autorelease]];
			}
			else if ([@"location" isEqualToString:[dic objectForKey:@"type"]]) 
			{
				CLLocation *location = [[[CLLocation alloc] initWithLatitude:[[dic objectForKey:@"lat"] floatValue] longitude:[[dic objectForKey:@"long"] floatValue]] autorelease];
				
				[chatHistory addObject:[[[ChatMessageModel alloc] initWithType:[@"my" isEqualToString:[dic objectForKey:@"my"]] 
																   typeMessage:ChatMessageTypeLocation 
																		  text:@"I'm here."
																		  file:nil
																	  location:location
																		  date:nil] autorelease]];
			} 
			else if ([@"image" isEqualToString:[dic objectForKey:@"type"]]) 
			{
				[chatHistory addObject:[[[ChatMessageModel alloc] initWithType:[@"my" isEqualToString:[dic objectForKey:@"my"]] 
																   typeMessage:ChatMessageTypeImage
																		  text:nil
																		  file:[[[FileModel alloc] initWithType:[dic objectForKey:@"fType"] thumbnail:[dic objectForKey:@"thumb"] file:[dic objectForKey:@"file"]] autorelease]
																	  location:nil
																		  date:nil] autorelease]];
			} 
			else if ([@"date" isEqualToString:[dic objectForKey:@"type"]]) 
			{
				[chatHistory addObject:[[[ChatMessageModel alloc] initWithType:YES 
																   typeMessage:ChatMessageStartDate
																		  text:nil
																		  file:nil
																	  location:nil
																		  date:nil] autorelease]];
			}
			
			if ([@"my" isEqualToString:[dic objectForKey:@"my"]])
				[(ChatMessageModel*)[chatHistory lastObject] setUserID:[NSString stringWithFormat:@"%i", user.mbUser.ID]];
			else
				[(ChatMessageModel*)[chatHistory lastObject] setUserID:self.userWith.userID];
			
			[[chatHistory lastObject] refreshAttachment];
			[[chatHistory lastObject] setMessageDate:[dic objectForKey:@"date"]];
		}
	}
	
	return chatHistory;
}

@end
