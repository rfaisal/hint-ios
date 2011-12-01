//
//
//
#import "AttachmentDataModel.h"

#import "Converter.h"

@implementation AttachmentDataModel

@synthesize attachmentType; 
@synthesize attachmentData;
@synthesize attachmentMIME;
@synthesize attachmentStatus;
@synthesize attachmentCaption;

- (void) dealloc {
	[attachmentType release]; 
	[attachmentData release];
	[attachmentMIME release];
	[attachmentStatus release];
	[attachmentCaption release];
	
	
	[super dealloc];
}

- (NSString*)stringForEditQuery {
	NSMutableString *string = [NSMutableString stringWithCapacity:0];
	
	[string appendString:@"<AttachmentUpdate>"];
		
	[string appendFormat:@"<UserID>%@</UserID>", self.userID];
	[string appendFormat:@"<AttachmentID>%@</AttachmentID>", self.attachID];
	if(attachmentCaption)
		[string appendFormat:@"<Caption><![CDATA[%@]]></Caption>", self.attachmentCaption];
	[string appendFormat:@"<Category>%@</Category>", [Converter stringByCategoryOfAttachement:self.attachCategory]];
	
	[string appendString:@"</AttachmentUpdate>"];
	
	return [string description];
	
}

@end
