//
//  CreateBlobQuery.h
//  BlobsService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobCreateQuery : QBBlobQuery {
	BOOL multipart;
}
@property (nonatomic) BOOL multipart;
@end
