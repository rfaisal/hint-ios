//
//  UserQuery.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUserQuery : QBGeoposServiceQuery {
@private
	QBUser* user;
}
@property (nonatomic,readonly) QBUser* user;
-(id)initWithUserData:(QBUser*)userData;
@end
