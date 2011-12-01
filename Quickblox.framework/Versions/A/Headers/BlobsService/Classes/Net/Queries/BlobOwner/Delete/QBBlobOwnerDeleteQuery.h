//
//  BLBlobOwnerDeleteQuery.h
//  BlobsService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobOwnerDeleteQuery : QBBlobOwnerQuery {
	NSUInteger blobOwnerID;
}
@property (nonatomic) NSUInteger blobOwnerID;
-(QBBlobOwnerDeleteQuery*)initWithBlobOwnerID:(NSUInteger)ID;
@end
