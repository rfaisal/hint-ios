//
//  BLBlobCreateAnswer.h
//  BlobsService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobCreateAnswer : QBBlobAnswer {
	QBBlobObjectAccessAnswer* blobObjectAccessAnswer;
}
@property (nonatomic,retain) QBBlobObjectAccessAnswer* blobObjectAccessAnswer;
@end
