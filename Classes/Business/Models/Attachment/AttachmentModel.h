//
//
//
#import "AttachmentModel.h"

@interface AttachmentModel : NSObject {
	NSString *attachID;
	NSInteger attachNumber;
	NSString *thumbnailURL;
	BOOL isPublic;
	NSInteger attachRating;
	enum AttachmentCategory attachCategory;	
	NSString *userID;
	
	BOOL selected;
	BOOL enabled;
	
	BOOL canSetSelected;
}

@property (nonatomic, retain) NSString *attachID;
@property (nonatomic) NSInteger attachNumber;
@property (nonatomic, retain) NSString *thumbnailURL;
@property (nonatomic) BOOL isPublic;
@property (nonatomic) NSInteger attachRating;
@property (nonatomic) enum AttachmentCategory attachCategory;	
@property (nonatomic,retain) NSString *userID;

@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL canSetSelected;

@end
