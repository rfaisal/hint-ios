//
//  QBCDeviceGetQuery.h
//  Mobserv
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBCDeviceGetQuery : QBCommonServiceQuery {
	NSUInteger deviceID;
}
@property (nonatomic) NSUInteger deviceID;
- (id)initWithDeviceID:(NSUInteger)deviceID;
@end
