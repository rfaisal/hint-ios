@interface BLBlobsService : NSObject {	}
+ (void)AuthorizeAppId:(NSUInteger)appID key:(NSString*)authKey secret:(NSString*)authSecret;
@end

//Blobs specific errors handling
extern NSString* const kBlobsServiceException;
//Blobs error domain
extern NSString* const kBlobsServiceErrorDomain;

//Exceptions
extern NSString* const kBlobsServiceExceptionUnknownOwnerType;

//Owner Types
extern NSString* const kBlobsServiceBlobOwnerTypeApplication;
extern NSString* const kBlobsServiceBlobOwnerTypeService;
extern NSString* const kBlobsServiceBlobOwnerTypeUser;

extern enum QBBlobSortByKind kBlobsServiceDefaultSort;
extern BOOL kBlobsServiceDefaultSortIsAsc;

//Blob Result
@class BLBlob;
@interface BLBlobResult : Result {}
@property (nonatomic,readonly) BLBlob* blob;
@end

//Blob File Result
@interface BLBlobFileResult : Result {}
@property (nonatomic,readonly) NSData* data;
@end

//Blob Search Result
@interface BLBlobSearchResult : Result {}

//Blob instances, that were found during search
@property (nonatomic,readonly) NSArray* blobs;

//Count of pages available for this search request
@property(nonatomic,readonly) NSUInteger pages;

//Number of current page
@property(nonatomic,readonly) NSUInteger currentPage;

//Request for specific page within current search request
-(BLBlobSearchResult*)askForPage:(NSUInteger)page;

//Shortcut to request next page
-(BLBlobSearchResult*)nextPage;

//Shortcut to request prevPage
-(BLBlobSearchResult*)prevPage;
@end

//Sorting
enum QBBlobSortByKind{
	//No sorting is performed
	QBBlobSortByKindNone = 0,
	
	//Sorting by Created date
	QBBlobSortByKindCreatedAt = 1,
	
	//Sorting by file size
	QBBlobSortByKindSize = 2
};

//Blob Search Request
@interface BLBlobSearchRequest : NSObject {}

// Filters

//  Blob idetifier
@property (nonatomic) NSUInteger blobID;

//  Blob creation date
@property (nonatomic, retain) NSDate* created_at;

//  Blob owner user identitfier
@property (nonatomic) NSUInteger userID;

//  Blob owner application identitfier
@property (nonatomic) NSUInteger appID;

//  Blob MIME content type 
// (see http://www.iana.org/assignments/media-types/ ) 
@property (nonatomic, retain) NSString* contentType;

//  Array of tags (keywords, associated with blob)
//  Only those blobs, which contain ALL of these tags
//  will be returned
@property (nonatomic, retain) NSArray* tags;

// Ranges

//  Minimum created date
@property (nonatomic, retain) NSDate* min_created_at;

//  Maximum created date
@property (nonatomic, retain) NSDate* max_created_at;

//  Maximum size
@property (nonatomic) NSUInteger min_size;

//  Minimum size
@property (nonatomic) NSUInteger max_size;


// Sorts

//  Sorting is ASC (NO by default)
@property (nonatomic) BOOL sort_asc;

//  Sorting type (QBBlobSortByKindNone by default)
@property (nonatomic) enum QBBlobSortByKind sort_by;


// Paging

//  Number of page to return
@property (nonatomic) NSUInteger page;

//  Page size (maximum number of blobs to return)
@property (nonatomic) NSUInteger pageSize;

//  Perform request on specific page and page size (other parameters are the same)
-(BLBlobSearchResult*)performWithPage:(NSUInteger)newPageNumber pageSize:(NSUInteger)newPageSize;

//  Perform request on specific page (other parameters are the same)
-(BLBlobSearchResult*)performWithPage:(NSUInteger)newPageNumber;
@end


//Blob
@interface BLBlob : NSObject {}

//Blob owner identifier
@property (nonatomic) NSUInteger ownerID;

//MIME content type 
//(see http://www.iana.org/assignments/media-types/ )
@property (nonatomic, retain) NSString* contentType;

//Name, i.e. file name
@property (nonatomic, retain) NSString* name;

//File size
@property (nonatomic,readonly) NSUInteger size;

//List of tags (keywords) associated with blob
@property (nonatomic, retain) NSArray* tags;

//File data
@property (nonatomic, retain) NSData* data;

//Unique identifier for file of this blob 
//It is used in GetBlob request
@property (nonatomic, readonly) NSString* UID;

//URL to the Blob data on server
@property (nonatomic, readonly) NSURL* URL;

//Blob information identifier
@property (nonatomic) NSUInteger ID;

//Should autosave on every change (NO by default)
//This is an expensive operation, choose wisely
@property (nonatomic) BOOL autosave;

//Create a blob
+ (BLBlobResult*)CreateBlob:(BLBlob*)blob;

//Delete specified blob
+ (Result*)DeleteBlob:(BLBlob*)blob;

//Update specified blob
+ (BLBlobResult*)UpdateBlob:(BLBlob*)blob;

//Get blob file
+ (BLBlobFileResult*)GetBlob:(NSString*)blobUID ;

//Get blob information
+ (BLBlobResult*)GetBlobInfo:(NSUInteger)blobId;

//Search for blobs
+ (BLBlobSearchResult*)FindForRequest:(BLBlobSearchRequest*)request;
@end

@class BLBlobOwner;
//Blob owner result
@interface BLBlobOwnerResult : Result {}
@property (nonatomic,readonly) BLBlobOwner* blobOwner;

@end

enum QBBlobOwnerType{
	QBBlobOwnerTypeApplication,
	QBBlobOwnerTypeService,
	QBBlobOwnerTypeUser
};

//Blob Owner
@interface BLBlobOwner : NSObject {}
@property (nonatomic) NSUInteger appID;
@property (nonatomic) NSUInteger serviceID;
@property (nonatomic) NSUInteger userID;
@property (nonatomic) enum QBBlobOwnerType ownerType;

+ (BLBlobOwnerResult*)CreateBlobOwner:(BLBlobOwner*)blobOwner;
+ (Result*)DeleteBlobOwner:(NSUInteger)blobOwnerID;
+ (BLBlobOwnerResult*)GetBlobOwner:(NSUInteger)blobOwnerID;

+ (NSObject<Cancelable>*)CreateBlobOwnerAsync:(BLBlobOwner*)blobOwner delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)DeleteBlobOwnerAsync:(NSUInteger)blobOwnerID delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)GetBlobOwnerAsync:(NSUInteger)blobOwnerID delegate:(NSObject<ActionStatusDelegate>*)delegate;
@end

