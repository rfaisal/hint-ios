//
//  QBNSubscriber.h
//  BaseServiceStaticLibrary
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNSubscriber : Entity {
	NSUInteger deviceTokenID;
	NSUInteger userID;
}
@property (nonatomic) NSUInteger deviceTokenID;
@property (nonatomic) NSUInteger userID;
@end
