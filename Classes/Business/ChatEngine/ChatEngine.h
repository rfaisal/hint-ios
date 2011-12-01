//
//  ChatEngine.h
//  
//


//
@class ChatEntry;
@class UserModel;

@interface ChatEngine : NSObject <ActionStatusDelegate, UIAlertViewDelegate> {
	NSMutableDictionary *chatsHistory;
	NSMutableDictionary *currentConversations;
	
	NSMutableArray *currentConversationsOrder;
	
	id<ChatProtocolDelegate> delegate;
	
	ChatEntry* currentChat;
	NSUInteger newMessagesCount;
}

@property (nonatomic, retain) id<ChatProtocolDelegate> delegate;

@property (nonatomic, retain) NSMutableDictionary *chatsHistory;
@property (nonatomic, retain) NSMutableDictionary *currentConversations;

@property (nonatomic, retain) NSMutableArray *currentConversationsOrder;

@property (nonatomic, readonly) NSArray *chats;

@property (nonatomic, retain) ChatEntry* currentChat;

@property (nonatomic) NSUInteger newMessagesCount;

+ (ChatEngine*)sharedEngine;
//- (void)loadHistoryForUser:(NSString*)name;
//- (void)saveHistoryForUser:(NSString*)name;

- (void)clearHistory;

- (NSUInteger) newMessageCountForUser:(NSString*)userID;

- (void) messageArrived:(NSDictionary*)notification;

- (ChatEntry*)showConversationViewForUser:(NSString*)userID userModel:(UserModel*)user;
- (void)showChatView;

@end
