//
//  QBNDeviceToken.h
//  NotifierServiceClient
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNDeviceToken : Entity {
	NSString* token;
	NSUInteger deviceId;
	BOOL test;
}
@property(nonatomic,retain) NSString* token;
@property(nonatomic) NSUInteger deviceId;
@property(nonatomic) BOOL test;
@end