//
//  QBNSendPushTask.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNSendPushTask : Task {
	NSUInteger subscriberID;
	NSUInteger externalUserID;
	NSUInteger userID;
	NSUInteger eventOwnerID;
	QBNPushMessage* pushMessage;
	QBNPushEvent* event;
}
@property (nonatomic) NSUInteger subscriberID;
@property (nonatomic) NSUInteger externalUserID;
@property (nonatomic) NSUInteger userID;
@property (nonatomic) NSUInteger eventOwnerID;
@property (nonatomic,retain) QBNPushMessage* pushMessage;
@property (nonatomic,retain) QBNPushEvent* event;

@end
