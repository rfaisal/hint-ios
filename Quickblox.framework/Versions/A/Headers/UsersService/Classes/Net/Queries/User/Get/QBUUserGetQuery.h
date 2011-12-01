//
//  QBUUserGetQuery.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUserGetQuery : QBUUserQuery {
	NSUInteger userID;
}
@property (nonatomic) NSUInteger userID;
- (id)initWithUserID:(NSUInteger)userID;
@end
