//
//
//
#import "AttachmentModel.h"

@implementation AttachmentModel

@synthesize attachID;
@synthesize thumbnailURL;

@synthesize attachNumber;
@synthesize isPublic;
@synthesize attachRating;
@synthesize attachCategory;

@synthesize userID;

@synthesize selected;
@synthesize enabled;
@synthesize canSetSelected;

- (void)dealloc {
	[attachID release];
	[thumbnailURL release];
	[userID release];
	
	[super dealloc];
}

@end
