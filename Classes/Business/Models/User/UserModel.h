//
//
//

@interface UserModel : NSObject<NSCopying> {
	NSString *userID;
	NSString *screenName;
	NSString *profileTitle;
	NSString *mainPhotoThumbnailURL;
	BOOL isOnline;
	BOOL isOnlineIPhone;
	BOOL isFriend;
	BOOL isFavourite;
	
}

@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *screenName;
@property (nonatomic, retain) NSString *profileTitle;
@property (nonatomic, retain) NSString *mainPhotoThumbnailURL;
@property (nonatomic) BOOL isOnline;
@property (nonatomic) BOOL isOnlineIPhone;
@property (nonatomic) BOOL isFriend;
@property (nonatomic) BOOL isFavourite;

- (id)initWithUserID:(NSString*)_userID thumbnailURL:(NSString*)url;
- (id)initWithUserID:(NSString*)_userID name:(NSString*)_name thumbnailURL:(NSString*)url;

@end
