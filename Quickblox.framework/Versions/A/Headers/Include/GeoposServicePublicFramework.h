

//User
@class QBUserResult, Result;
@interface QBUser : NSObject {}

@property (nonatomic) NSUInteger appID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* group;
@property (nonatomic) NSUInteger ID;
@property (nonatomic) BOOL autosave;
+ (QBUserResult*)CreateUser:(QBUser*)user;
+ (QBUserResult*)EditUser:(QBUser*)user;
+ (Result*)DeleteUser:(QBUser*)user;
+ (QBUserResult*)GetUser:(NSUInteger)userId;
@end

//Result
@interface Result : NSObject {}
@property (nonatomic,readonly) NSMutableArray* errors;
@property (nonatomic,readonly) BOOL success;
@end

//User Result
@interface QBUserResult : Result {}
@property (nonatomic,readonly) QBUser* user;
@end


//QBGeoData
@class QBGeoDataResult,QBGeoDataSearchRequest,QBGeoDataSearchResult;
@interface QBGeoData : NSObject {}
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic, retain) NSDate* created_at;
@property (nonatomic, retain) QBUser* user;
@property (nonatomic, retain) NSString* status;

+ (QBGeoDataResult*)CreateGeoData:(QBGeoData*)geodata;
+ (QBGeoDataSearchResult*)FindForRequest:(QBGeoDataSearchRequest*)request;
+ (QBGeoData*)currentGeoData;
@end



//QBGeoData Result
@interface QBGeoDataResult : Result {}
@property (nonatomic,readonly) QBGeoData* geoData;
@end

//QBGeoData Search Result
@interface QBGeoDataSearchResult : Result {}
@property (nonatomic,readonly) NSArray* geodatas;
@property(nonatomic,readonly) NSUInteger pages;
@property(nonatomic,readonly) NSUInteger currentPage;
-(QBGeoDataSearchResult*)askForPage:(NSUInteger)page;
-(QBGeoDataSearchResult*)nextPage;
-(QBGeoDataSearchResult*)prevPage;
@end

//QBGeoData Search Request

enum QBGeoDataSortByKind {
	GeoDataSortByKindNone,
	GeoDataSortByKindCreatedAt,
	GeoDataSortByKindLatitude,
	GeoDataSortByKindLongitude,
	GeoDataSortByKindDistance,
	GeoDataSortByKindUserName,
	GeoDataSortByKindUserGroup
};
struct QBGeoDataRect {
	CLLocationCoordinate2D coord1;
	CLLocationCoordinate2D coord2;
};

@interface QBGeoDataSearchRequest : NSObject {}
// Filters
@property (nonatomic) NSUInteger geoDataID;
@property (nonatomic, retain) NSDate* created_at;
@property (nonatomic) NSUInteger userID;
@property (nonatomic) NSUInteger userAppID;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* userGroup;
// Diapazones
@property (nonatomic, retain) NSDate* min_created_at;
@property (nonatomic, retain) NSDate* max_created_at;
@property (nonatomic) struct QBGeoDataRect geo_rect;
@property (nonatomic) NSInteger radius;
// Sorting
@property (nonatomic) BOOL sort_asc;
@property (nonatomic) enum QBGeoDataSortByKind sort_by;
// Special
@property (nonatomic) BOOL last_only;
@property (nonatomic) CLLocationCoordinate2D current_position;
// Paging
@property (nonatomic) NSUInteger page;
@property (nonatomic) NSUInteger pageSize;
-(QBGeoDataSearchResult*)performWithPage:(NSUInteger)newPageNumber pageSize:(NSUInteger)newPageSize;
-(QBGeoDataSearchResult*)performWithPage:(NSUInteger)newPageNumber;
@end

