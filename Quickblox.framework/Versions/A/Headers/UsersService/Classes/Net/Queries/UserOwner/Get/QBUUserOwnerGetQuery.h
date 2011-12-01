//
//  QBUUserOwnerGetQuery.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUserOwnerGetQuery : QBUUserOwnerQuery {
	NSUInteger userOwnerID;
}
@property (nonatomic) NSUInteger userOwnerID;
- (id)initWithOwnerID:(NSUInteger)userOwnerID;
@end
