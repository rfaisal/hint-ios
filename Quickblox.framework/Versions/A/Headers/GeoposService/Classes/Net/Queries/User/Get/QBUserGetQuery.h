//
//  UserGetQuery.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//


@interface QBUserGetQuery : QBUserQuery
{
	NSUInteger userId;
}
@property (nonatomic) NSUInteger userId;

-(id)initWithUserId:(NSUInteger)userid;

@end
