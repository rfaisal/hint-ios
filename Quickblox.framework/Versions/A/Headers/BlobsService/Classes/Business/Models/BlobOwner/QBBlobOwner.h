//
//  BLBLobOwner.h
//  BlobsService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBBlobOwnerResult;
@interface QBBlobOwner : Entity {
	NSUInteger appID;
	NSUInteger serviceID;
	NSUInteger userID;
	enum QBBlobOwnerType ownerType;
}
@property (nonatomic) NSUInteger appID;
@property (nonatomic) NSUInteger serviceID;
@property (nonatomic) NSUInteger userID;
@property (nonatomic) enum QBBlobOwnerType ownerType;
@property (nonatomic,readonly) NSUInteger ownerEntityID;

+ (NSString*)ownerTypeName:(enum QBBlobOwnerType)type;
- (NSString*)ownerTypeName;

+ (QBBlobOwnerResult*)CreateBlobOwner:(QBBlobOwner*)blobOwner;
+ (Result*)DeleteBlobOwner:(NSUInteger)blobOwnerID;
+ (QBBlobOwnerResult*)GetBlobOwner:(NSUInteger)blobOwnerID;

+ (NSObject<Cancelable>*)CreateBlobOwnerAsync:(QBBlobOwner*)blobOwner delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)DeleteBlobOwnerAsync:(NSUInteger)blobOwnerID delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)GetBlobOwnerAsync:(NSUInteger)blobOwnerID delegate:(NSObject<ActionStatusDelegate>*)delegate;

@end
