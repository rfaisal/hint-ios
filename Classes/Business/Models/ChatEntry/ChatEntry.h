//
//  ChatEntry.h
//


@class UserModel;
@class ChatMessageModel;

@interface ChatEntry : NSObject {
	NSString *oponent;
	UserModel *userWith;
	NSInteger newMessageCount, initialPageIndex, lastPageIndex;
	
	NSMutableArray *pagedHistory;
	
	BOOL openSession;	
}

@property (nonatomic, retain) NSString *oponent;
@property (nonatomic, retain) UserModel *userWith;
@property (nonatomic, retain) NSMutableArray *pagedHistory;

@property (nonatomic) NSInteger newMessageCount, initialPageIndex, lastPageIndex;
@property (nonatomic) BOOL openSession;

- (void) addMessage:(ChatMessageModel*)message;

- (void) saveHistory;
- (void) loadHistory;
- (NSMutableArray*) loadHistoryFromPage:(NSInteger)page;

@end
