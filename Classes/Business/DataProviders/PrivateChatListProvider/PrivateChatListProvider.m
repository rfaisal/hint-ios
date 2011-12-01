//
//  ChatListProvider.m
//  SuperSample
//
//  Created by Danil on 14.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "PrivateChatListProvider.h"

#import "PrivateMessages.h"

@implementation PrivateChatListProvider



static id instance = nil;

+ (id)sharedProvider {
	@synchronized (self)
	{
		if (instance == nil)
		{
			instance = [[self alloc] init];
		}
	}
	return instance;
}
+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [super allocWithZone:zone];
			return instance;
		}
	}
	return nil;
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)retain {
	return self;
}
- (NSUInteger)retainCount {
	return NSUIntegerMax;
}

- (void)release {
}

- (id)autorelease {
	return self;
}

- (NSString *)entityName {
    return @"PrivateMessages";
}

- (PrivateMessages*)addMessageWithUID:(NSString*)uid text:(NSString*)text location:(NSString*)location
{
	return [self addMessageWithUID:uid text:text location:location context:self.managedObjectContext];
}

- (PrivateMessages*)addMessageWithUID:(NSString*)uid 
						  text:(NSString*)text 
					  location:(NSString*)location 
					   context:(NSManagedObjectContext*)context
{
    PrivateMessages *model = (PrivateMessages *)[NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                                        inManagedObjectContext:context];
                                                                        
	model.uid = [NSNumber numberWithDouble:[uid doubleValue]];
    model.text = text;
    model.location = location;
    
	NSError **error=nil;
	if (![context save:error]) 
	{
		return nil;
	}
	
	return model;
}

- (PrivateMessages*)messageByID:(NSManagedObjectID*)mid error:(NSError**)error {
    PrivateMessages* message = (PrivateMessages*)[self.managedObjectContext existingObjectWithID:mid error:error];
	
    if(error)
	{
	}
    
	return message;
}


@end
