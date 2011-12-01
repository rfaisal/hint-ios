//
//
//
#import "AttachmentModel.h"

@interface AttachmentDataModel : AttachmentModel {
	NSString *attachmentType; 
	NSString *attachmentData;
	NSString *attachmentMIME;
	NSString *attachmentStatus;
	NSString *attachmentCaption;
}

@property (nonatomic, retain) NSString *attachmentType; 
@property (nonatomic, retain) NSString *attachmentData;
@property (nonatomic, retain) NSString *attachmentMIME;
@property (nonatomic, retain) NSString *attachmentStatus;
@property (nonatomic, retain) NSString *attachmentCaption;

- (NSString*)stringForEditQuery;

@end
