//
//  QBCDeviceCreateQuery.h
//  CommonServiceClient
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBCDeviceCreateQuery : QBCDeviceQuery {
	QBCDevice* device;
}
@property (nonatomic,retain) QBCDevice* device;
- (id)initWithDevice:(QBCDevice*)device;
@end
