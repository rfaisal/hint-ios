//
//  QBNSubscribeOnEventQuery.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNSubscribeOnEventQuery : QBNotifierServiceQuery {
	NSUInteger eventID;
	NSUInteger subscriberID;
	NSUInteger externalUserID;
	NSUInteger userID;
}
@property (nonatomic) NSUInteger eventID;
@property (nonatomic) NSUInteger subscriberID;
@property (nonatomic) NSUInteger externalUserID;
@property (nonatomic) NSUInteger userID;

@end
