//
//
//
#import "UserModel.h"

@implementation UserModel

@synthesize userID;
@synthesize screenName;
@synthesize profileTitle;
@synthesize mainPhotoThumbnailURL;
@synthesize isOnline;
@synthesize isOnlineIPhone;
@synthesize isFriend;
@synthesize isFavourite;

- (void)dealloc {
	[userID release];
	[screenName release];
	[profileTitle release];
	[mainPhotoThumbnailURL release];
	
	[super dealloc];
}

- (id)initWithUserID:(NSString*)_userID thumbnailURL:(NSString*)url {
	if (self = [super init]) {
		self.userID = _userID;
		self.mainPhotoThumbnailURL = url;
	}
	return self;
}
- (id)initWithUserID:(NSString*)_userID name:(NSString*)_name thumbnailURL:(NSString*)url {
	if (self = [super init]) {
		self.userID = _userID;
		self.screenName = _name;
		self.mainPhotoThumbnailURL = url;
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone{
	UserModel* userCopy = [[self class] allocWithZone:zone];
	userCopy.userID = [userID copyWithZone:zone];
	userCopy.screenName = [screenName copyWithZone:zone];
	userCopy.profileTitle = [profileTitle copyWithZone:zone];
	userCopy.mainPhotoThumbnailURL = [mainPhotoThumbnailURL copyWithZone:zone];
	userCopy.isOnline = isOnline;
	userCopy.isOnlineIPhone = isOnlineIPhone;
	userCopy.isFriend = isFriend;
	userCopy.isFavourite = isFavourite;
	return userCopy;
}
@end
