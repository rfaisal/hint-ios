//
//  ChatMessageModel.h
//  
//


//

@class FileModel;

@interface ChatMessageModel : NSObject <ActionStatusDelegate> {
	enum ChatMessageType messageType;
	BOOL my;
	
	NSString* userID;

	NSDate *messageDate;
	
	NSString *text;
	CLLocation *location;
	FileModel *file;
}

@property (nonatomic) enum ChatMessageType messageType;
@property (nonatomic) BOOL my;

@property (nonatomic, retain) NSString* userID;

@property (nonatomic, retain) NSDate *messageDate;

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) FileModel *file;

- (id)initWithType:(BOOL)myM typeMessage:(enum ChatMessageType)mType text:(NSString *)string file:(FileModel*)f location:(CLLocation*)loc date:(NSDate*)date;

- (void) refreshAttachment;
@end