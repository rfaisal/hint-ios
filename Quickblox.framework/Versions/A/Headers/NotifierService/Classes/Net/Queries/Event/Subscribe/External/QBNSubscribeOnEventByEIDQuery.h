//
//  QBNSubscribeOnEventByEIDQuery.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNSubscribeOnEventByEIDQuery : QBNotifierServiceQuery {
	NSUInteger eventID;
	NSUInteger externalUserID;
}
@property (nonatomic) NSUInteger eventID;
@property (nonatomic) NSUInteger externalUserID;
@end
