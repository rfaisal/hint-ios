//
//  QBCDevice.h
//  CommonServiceClient
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBCDevice : Entity {
	NSString* UDID;
}
@property (nonatomic,retain) NSString* UDID;
- (id)initWithCurrentDevice;
- (id)initWithDeviceUDID:(NSString*)UDID;
@end
