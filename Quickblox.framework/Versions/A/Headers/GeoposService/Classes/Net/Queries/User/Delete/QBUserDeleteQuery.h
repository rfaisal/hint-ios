//
//  UserDeleteQuery.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUserDeleteQuery : QBUserQuery {
@private
	NSUInteger userId;
}
@property (nonatomic,readonly) NSUInteger userId;

-(id)initWithUserId:(NSUInteger)userid;

@end