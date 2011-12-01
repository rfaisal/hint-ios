//
//  FileModel.m
//  
//


//
#import "FileModel.h"
#import "AttachmentDataModel.h"

@implementation FileModel

@synthesize type;
@synthesize urlThambneil;
@synthesize urlFile;

@synthesize attachement;

#pragma mark -
#pragma mark Dealloc

- (void) dealloc {
	[type release];
	[urlThambneil release];
	[urlFile release];
	[attachement release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Init

- (id)initWithType:(NSString*)t thumbnail:(NSString*)thumb file:(NSString*)file {
	if (self = [super init]) {
		self.type = t;
		self.urlThambneil = thumb;
		self.urlFile = file;
		
		self.attachement = [[[AttachmentDataModel alloc] init] autorelease];
	}
	return self;
}

@end
