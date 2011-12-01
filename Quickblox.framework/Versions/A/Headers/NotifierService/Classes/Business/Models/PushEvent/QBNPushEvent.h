//
//  QBNPushEvent.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNPushEvent : QBNEvent {
	QBNPushMessage* pushMessage;
}
@property (nonatomic,retain) QBNPushMessage* pushMessage;


@end
