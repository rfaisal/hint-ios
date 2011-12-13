//
//  ChatListProvider.m
//  SuperSample
//
//  Created by Danil on 14.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "ChatListProvider.h"

#import "Messages.h"

@implementation ChatListProvider

static id instance = nil;

+ (id)sharedProvider {
	@synchronized (self){
		if (instance == nil){
			instance = [[self alloc] init];
		}
	}
	return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self){
		if (instance == nil){
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

- (oneway void)release {
}

- (id)autorelease {
	return self;
}

- (NSString *)entityName {
    return @"Messages";
}

- (Messages *)addMessageWithUID:(NSString *)uid text:(NSString *)text location:(NSString *)location user:(Users *)user date:(NSDate *)date{
	return [self addMessageWithUID:uid text:text location:location user:user date:date context:self.managedObjectContext];
}

- (Messages *)addMessageWithUID:(NSString *)uid 
						  text:(NSString *)text 
					  location:(NSString *)location 
                           user:(Users *)user
                           date:(NSDate *)date
					   context:(NSManagedObjectContext *)context{
    
    Messages *model = (Messages *)[NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                                        inManagedObjectContext:context];
                                                                        
	model.uid = [NSNumber numberWithDouble:[uid doubleValue]];
    model.text = text;
    model.location = location;
    model.user = user;
    model.date = date;
    
	NSError **error=nil;
	if (![context save:error]){
		return nil;
	}
	
	return model;
}

- (Messages *)messageByID:(NSManagedObjectID *)mid error:(NSError **)error {
    Messages *message = (Messages *)[self.managedObjectContext existingObjectWithID:mid error:error];

	return message;
}

- (Messages *)messageByUID:(NSNumber *)uid {
	return [self messageByUID:uid context:self.managedObjectContext];
}

- (Messages *)messageByUID:(NSNumber *)uid context:(NSManagedObjectContext *)context {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] 
											  inManagedObjectContext:context];
	[request setEntity:entity];
	[request setPredicate:[NSPredicate predicateWithFormat:@"uid == %u",[uid intValue]]];
	NSArray* results = [context executeFetchRequest:request error:nil];
    [request release];
	
	Messages *message = nil;
	if(nil != results && [results count] > 0){
		message = (Messages *)[results objectAtIndex:0];
	}
	
	return message;
}

// serach by userLogin + message
- (Messages *)messageByUser:(NSUInteger)userID message:(NSString *)text{
    return [self messageByUser:userID message:text context:self.managedObjectContext];
}

- (Messages *)messageByUser:(NSUInteger)userID message:(NSString *)text context:(NSManagedObjectContext *)context{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] 
											  inManagedObjectContext:context];
	[request setEntity:entity];
	[request setPredicate:[NSPredicate predicateWithFormat:@"text == %@ AND user.uid == %u", text, userID]];
	NSArray *results = [context executeFetchRequest:request error:nil];
	
	Messages *message = nil;
	if(nil != results && [results count] > 0){
		message = (Messages *)[results objectAtIndex:0];
	}
	
	return message;
}

@end