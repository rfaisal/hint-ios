//
//  User.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBUserResult, Result;
@interface QBUser : Entity {
@private
	NSUInteger appID;	
	NSString* name;
	NSString* group;	
}
@property (nonatomic) NSUInteger appID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* group;

+ (QBUserResult*)CreateUser:(QBUser*)user;
+ (QBUserResult*)EditUser:(QBUser*)user;
+ (Result*)DeleteUser:(QBUser*)user;
+ (QBUserResult*)GetUser:(NSUInteger)userId;

@end
