//
//  QBBlobObjectAccess.h
//  Mobserv
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobObjectAccess : Entity {
	NSUInteger blobID;
	enum QBBlobObjectAccessType type;
	NSDate* expires;
	NSString* urlWithParams;
	NSDictionary* params;
	NSURL* url;
}
@property (nonatomic) NSUInteger blobID;
@property (nonatomic) enum QBBlobObjectAccessType type;
@property (nonatomic,retain) NSDate* expires;
@property (nonatomic,retain) NSString* urlWithParams;
@property (nonatomic,readonly) BOOL expired;
@property (nonatomic,retain) NSDictionary* params;
@property (nonatomic,retain) NSURL* url;
- (void)subscibe;
- (void)unsubscribe;
@end
