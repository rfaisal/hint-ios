//
//  QBUUserGetExternalQuery.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUserGetExternalQuery : QBUUserQuery {
	NSUInteger externalUserID;
}
@property (nonatomic) NSUInteger externalUserID;
- (id)initWithExternalUserID:(NSUInteger)externalUserID;
@end