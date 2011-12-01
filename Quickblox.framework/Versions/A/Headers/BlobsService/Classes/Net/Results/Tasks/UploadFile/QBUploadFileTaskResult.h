//
//  UploadFileTaskResult.h
//  Mobserv
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUploadFileTaskResult : TaskResult {
@private
	QBBlob* uploadedFileBlob;
}
@property (nonatomic,readonly) QBBlob* uploadedFileBlob;
+ (QBUploadFileTaskResult*)resultWithBlob:(QBBlob*)uploadedFileBlob;
@end
