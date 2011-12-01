//
//  Blob.h
//  BlobsService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBBlobResult, QBBlobSearchRequest, QBBlobSearchResult, QBBlobFileResult;

/** QBBlob class declaration */

/** This class provide methods to work with Blobs.*/

/** Limitations: max size of file is 5368709120 bytes (5 GB). */

@interface QBBlob : Entity 
{
	NSUInteger ownerID;             /// id of the file's owner
	NSString* contentType;          /// mime type of content
	NSString* name;                 /// file's name
	NSArray* tags;                  /// key values
	NSData* data;
	enum QBBlobStatus status;       /// this is the status of blob
	NSString* extendedStatus;       /// extended information about the status (optional). Usually it uses with Locked status
	NSDate* completedAt;            /// Date
	NSUInteger size;                /// the size of the file in bytes
	NSString* UID;                  /// unique id of file in the system            
}

/** id of the file's owner */
@property (nonatomic) NSUInteger ownerID;

/** Maximal lenght is 30 symbols */
@property (nonatomic, retain) NSString* contentType;

/** The name of the file
 *  Format - Filename.G
 *  minimal lenght is 3 symbols
 *  maximal lenght is 30 symbols
 */
@property (nonatomic, retain) NSString* name;

/** The size of file in bytes
 *  minimal value is 1
 *  maximal value is 5368709120
 */
@property (nonatomic) NSUInteger size;

/** Key values
 *  Format: IdentifierList.G
 *  Optional
 */
@property (nonatomic, retain) NSArray* tags;

@property (nonatomic, retain) NSData* data;

/** this is the status of blob */
@property (nonatomic) enum QBBlobStatus status;

/** extended information about the status (optional). Usually it uses with Locked status */
@property (nonatomic, retain) NSString* extendedStatus;

/** Date
 *  must be used if the blob_status == Complete
 */
@property (nonatomic, retain) NSDate* completedAt;

/** Fixed length - 32 symbols
 *  first 32 symbols are the generated UUID, the last 2 symbols are always "00"
 */
@property (nonatomic, retain) NSString* UID;
@property (nonatomic, readonly) NSURL* URL;

+ (QBBlobResult*)CreateBlob:(QBBlob*)blob;
+ (Result*)DeleteBlob:(QBBlob*)blob;
+ (QBBlobResult*)UpdateBlob:(QBBlob*)blob;
+ (QBBlobFileResult*)GetBlob:(NSString*)blobUID ;
+ (QBBlobResult*)GetBlobInfo:(NSUInteger)blobId;
+ (QBBlobSearchResult*)FindForRequest:(QBBlobSearchRequest*)request;

/** @name Blob : creation */

/** @param delegate object for callback
    @param blob which we would be created */
+ (NSObject<Cancelable>*)CreateBlobAsync:(QBBlob*)blob delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)DeleteBlobAsync:(QBBlob*)blob delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)UpdateBlobAsync:(QBBlob*)blob delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)GetBlobAsync:(NSString*)blobUID delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)GetBlobInfoAsync:(NSUInteger)blobId delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)FindForRequestAsync:(QBBlobSearchRequest*)request delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSString*)URLWithUID:(NSString*)uid;

@end
