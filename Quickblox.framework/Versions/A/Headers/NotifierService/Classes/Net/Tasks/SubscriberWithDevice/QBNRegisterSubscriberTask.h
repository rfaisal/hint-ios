//
//  QBNRegisterSubscriberWithDeviceTask.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNRegisterSubscriberTask : Task {
	QBCDevice* device;
	QBUUser* user;
	QBNDeviceToken* deviceToken;
    NSString* testToken;
}
@property (nonatomic,retain) QBCDevice* device;
@property (nonatomic,retain) QBUUser* user;
@property (nonatomic,retain) QBNDeviceToken* deviceToken;
@property (nonatomic,retain) NSString* testToken;
@end
