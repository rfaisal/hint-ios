//
//  BLBlobSearchAnswer.h
//  BlobsService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobSearchAnswer : PagedAnswer {
	NSMutableArray* blobs;
	QBBlobAnswer* blobAnswer;
}

@property (nonatomic, retain) NSMutableArray* blobs;
@property (nonatomic, retain) QBBlobAnswer* blobAnswer;

@end
