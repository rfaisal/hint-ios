//
//  BlobResult.h
//  BlobsService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobResult : Result {
@protected
	QBBlob* blob;
}
@property (nonatomic,readonly) QBBlob* blob;

@end
