//
//  BlobsService.h
//  BlobsService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobsService : BaseService {

}
+ (QBBlobCreateResult*)CreateBlob:(QBBlob*)blob;
+ (Result*)DeleteBlob:(NSUInteger)blobID;
+ (QBBlobResult*)GetBlobInfo:(NSUInteger)blobID;
+ (QBBlobFileResult*)GetBlob:(NSString*)blobUID;
+ (QBBlobResult*)UpdateBlob:(QBBlob*)blob;
+ (QBBlobSearchResult*)FindBlob:(QBBlobSearchRequest*)blobRequest;

+ (NSObject<Cancelable>*)CreateBlobAsync:(QBBlob*)blob delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)DeleteBlobAsync:(NSUInteger)blobID delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)GetBlobInfoAsync:(NSUInteger)blobID delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)GetBlobAsync:(NSString*)blobUID delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)UpdateBlobAsync:(QBBlob*)blob delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)FindBlobAsync:(QBBlobSearchRequest*)blobRequest delegate:(NSObject<ActionStatusDelegate>*)delegate;


+ (QBBlobOwnerResult*)CreateBlobOwner:(QBBlobOwner*)blobOwner;
+ (Result*)DeleteBlobOwner:(NSUInteger)blobOwnerID;
+ (QBBlobOwnerResult*)GetBlobOwner:(NSUInteger)blobOwnerID;

+ (NSObject<Cancelable>*)CreateBlobOwnerAsync:(QBBlobOwner*)blobOwner delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)DeleteBlobOwnerAsync:(NSUInteger)blobOwnerID delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)GetBlobOwnerAsync:(NSUInteger)blobOwnerID delegate:(NSObject<ActionStatusDelegate>*)delegate;

+ (Result*)UploadData:(NSData*)data access:(QBBlobObjectAccess*)writeAccess inBlob:(QBBlob*)blob;
+ (Result*)UploadFile:(NSString*)path access:(QBBlobObjectAccess*)writeAccess inBlob:(QBBlob*)blob;

+ (NSObject<Cancelable>*)UploadDataAsync:(NSData*)data 
								  access:(QBBlobObjectAccess*)writeAccess 
								  inBlob:(QBBlob*)blob
								delegate:(NSObject<ActionStatusDelegate>*)delegate;

+ (NSObject<Cancelable>*)UploadFileAsync:(NSString*)path 
								  access:(QBBlobObjectAccess*)writeAccess 
								  inBlob:(QBBlob*)blob 
								delegate:(NSObject<ActionStatusDelegate>*)delegate;


+ (Result*)CompleteBlob:(QBBlob*)blob;
+ (NSObject<Cancelable>*)CompleteBlobAsync:(QBBlob*)blob delegate:(NSObject<ActionStatusDelegate>*)delegate;

+ (QBUploadFileTaskResult*)TUploadFile:(NSString*)filePath ownerID:(NSUInteger)blobOwnerID;
+ (QBUploadFileTaskResult*)TUploadData:(NSData*)fileData 
								ownerID:(NSUInteger)blobOwnerID
							   fileName:(NSString*)fileName
							contentType:(NSString*)contentType;

+ (NSObject<Cancelable>*)TUploadFileAsync:(NSString*)filePath ownerID:(NSUInteger)blobOwnerID delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)TUploadDataAsync:(NSData*)fileData
								  ownerID:(NSUInteger)blobOwnerID
								 fileName:(NSString*)fileName
							  contentType:(NSString*)contentType
								 delegate:(NSObject<ActionStatusDelegate>*)delegate;
@end
