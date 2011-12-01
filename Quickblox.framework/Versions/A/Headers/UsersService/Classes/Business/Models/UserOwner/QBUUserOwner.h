//
//  QBUUserOwner.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUserOwner : Entity {
	NSUInteger appID;
	NSUInteger serviceID;
	enum QBUUserOwnerType ownerType;
}
@property (nonatomic) NSUInteger appID;
@property (nonatomic) NSUInteger serviceID;
@property (nonatomic) enum QBUUserOwnerType ownerType;
@property (nonatomic,readonly) NSUInteger ownerEntityID;

+ (NSString*)ownerTypeName:(enum QBUUserOwnerType)type;
- (NSString*)ownerTypeName;
@end
