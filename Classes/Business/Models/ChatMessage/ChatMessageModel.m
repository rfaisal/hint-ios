//
//  ChatMessageModel.m
//  
//


//
#import "ChatMessageModel.h"
#import "FileModel.h"

@implementation ChatMessageModel

@synthesize messageType;
@synthesize my;

@synthesize userID;

@synthesize messageDate;

@synthesize text;
@synthesize file;
@synthesize location;

- (void) dealloc {
	[userID release];
	
	[messageDate release];
	
	[text release];
	[file release];
	[location release];
	
	[super dealloc];
}

- (id)initWithType:(BOOL)myM typeMessage:(enum ChatMessageType)mType text:(NSString *)string file:(FileModel*)f location:(CLLocation*)loc date:(NSDate*)date {
	if (self = [super init]) {
		self.my = myM;
		self.messageType = mType;
		self.messageDate = date;
		self.text = string;
		self.file = f;
		self.location = loc;
	}
	return self;
}

- (void) refreshAttachment {
	if (file && userID)
		if ([self.file.type isEqualToString:kFileModelAttachement]) {
//			GetAttachmentQuery* query = [[[GetAttachmentQuery alloc] initWithUserID:userID attachmentID:file.urlFile] autorelease];
//			[query performAsyncWithDelegate:self];
		}
}

#pragma mark -
#pragma mark ActionStatusDelegate

- (void) completedWithResult:(Result*)result{
//	self.file.attachement.thumbnailURL = ((GetAttachmentResult*)result).attData.thumbnailURL;
//	self.file.attachement.attachmentData = ((GetAttachmentResult*)result).attData.attachmentData;
//	self.file.attachement.userID = ((GetAttachmentResult*)result).attData.userID;
//	self.file.attachement.attachID = ((GetAttachmentResult*)result).attData.attachID;
//	self.file.attachement.isPublic = YES;
}

@end
