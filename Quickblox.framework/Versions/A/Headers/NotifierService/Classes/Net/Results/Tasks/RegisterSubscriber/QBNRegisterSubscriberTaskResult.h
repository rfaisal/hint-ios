//
//  QBNRegisterDeviceSubscriberTaskResult.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNRegisterSubscriberTaskResult : TaskResult {
	QBNSubscriber* subscriber;
}
@property (nonatomic,retain) QBNSubscriber* subscriber;
@end
