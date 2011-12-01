//
//  EntityAnswer.h
//  BaseService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EntityAnswer : QBBaseServiceAnswer {
	Entity* entity;
}
@property (nonatomic,retain) Entity* entity;

+ (NSString*)entityElementName;
+ (Class)entityClass;

@end
