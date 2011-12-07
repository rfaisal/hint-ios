//
//  UsersProvider.m
//  SuperSample
//
//  Created by Danil on 19.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "UsersProvider.h"
#import "Users.h"
#import "SourceImages.h"
#import "SourceImagesProvider.h"

@implementation UsersProvider

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

- (oneway void)release {
}

- (id)autorelease {
	return self;
}

- (NSString *)entityName {
    return @"Users";
}

- (Users*)userByID:(NSManagedObjectID *)mid error:(NSError **)error {	
	return [self userByID:mid context:self.managedObjectContext error:error];
}

- (Users*)userByID:(NSManagedObjectID*)mid context:(NSManagedObjectContext*)context error:(NSError**)error {
    Users *user = (Users *)[context existingObjectWithID:mid error:error];
    
	return user;
}

- (Users*)userByUID:(NSNumber*)uid {
	return [self userByUID:uid context:self.managedObjectContext];
}

- (Users*)userByUID:(NSNumber*)uid context:(NSManagedObjectContext*)context {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] 
											  inManagedObjectContext:context];
	[request setEntity:entity];
	[request setPredicate:[NSPredicate predicateWithFormat:@"uid = %i",[uid intValue]]];
	NSArray* results = [context executeFetchRequest:request error:nil];
	
	Users *user = nil;
	if(nil != results && [results count] > 0){
		user = (Users*)[results objectAtIndex:0];
	}
	
	return user;
}

- (BOOL)updateOrCreateUser:(QBUUser *)qbUser location:(CLLocation *)location error:(NSError **)error{
	return [self updateOrCreateUser:qbUser location:location context:self.managedObjectContext error:error];
}

- (BOOL)updateOrCreateUser:(QBUUser *)qbUser location:(CLLocation*)location context:(NSManagedObjectContext*)context error:(NSError**)error{
    NSNumber *uid = [NSNumber numberWithUnsignedInteger:qbUser.ID];

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] 
											  inManagedObjectContext:context];
	[request setEntity:entity];
	[request setPredicate:[NSPredicate predicateWithFormat:@"uid = %i",[uid intValue]]];
	NSArray *results = [context executeFetchRequest:request error:error];
    [request release];
	
	Users *user = nil;
	BOOL isChanged = NO;
    
	if(nil != results && [results count] > 0){
		user = (Users *)[results objectAtIndex:0];
	}else {
		user = (Users *)[NSEntityDescription insertNewObjectForEntityForName:[self entityName]
													 inManagedObjectContext:context];
		user.uid = uid;
        user.mbUser = qbUser;
		
		isChanged = YES;
	}
	
	if([user.longitude doubleValue] != location.coordinate.longitude){
		user.longitude = [NSNumber numberWithDouble: location.coordinate.longitude];
		isChanged = YES;
	}
	
	if([user.latitude doubleValue] != location.coordinate.latitude){
		user.latitude = [NSNumber numberWithDouble: location.coordinate.latitude];
		isChanged = YES;
	}
	
	return isChanged;
}

- (Users *)createEmptyUser{
    return [self addUserWithUID:nil name:nil location:nil context:self.managedObjectContext];
}

- (Users *)addUserWithUID:(NSNumber*)uid name:(NSString*)name location: (CLLocation*) location{
	return [self addUserWithUID:uid name:name location:location context:self.managedObjectContext];
}

- (Users *)addUserWithUID:(NSNumber*)uid name:(NSString*)name location: (CLLocation*) location context:(NSManagedObjectContext*)context{
    Users *model = (Users *)[NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                            inManagedObjectContext:context];
	model.uid = uid;
    //model.user_name = name;
    NSLog(@"add user with name: %@", name);
    model.longitude =[NSNumber numberWithDouble: location.coordinate.longitude];
    model.latitude=[NSNumber numberWithDouble: location.coordinate.latitude];
    
	NSError **error=nil;
	if (![context save:error]) {
		return nil;
	}
	
	return model;
}

- (void) saveUser{
    NSError **error=nil;
    
	[self.managedObjectContext save:error];
}

- (Users *)sourceUserWithID:(NSString*)uid 
						avatarID:(NSManagedObjectID*)avatarId 					   
						  operation:(NSString *)operation
							context:(NSManagedObjectContext*)context {
	Users *user = nil;
		
	if(nil == uid){
		return nil;
	}
	
	if([operation isEqualToString:kNewOperation]){
		user = (Users *)[NSEntityDescription insertNewObjectForEntityForName:[self entityName]
																	inManagedObjectContext:context];
		
		user.uid = [NSNumber numberWithLong:[uid integerValue]];
		
		SourceImages *sourceImage = [[SourceImagesProvider sharedProvider] imageByID:avatarId error:nil];
		[user setPhoto:sourceImage];
		
		//[StorageProvider saveContext:context];
	
    }else if([operation isEqualToString:kChangedOperation]){
		user = (Users*)[self modelByID:uid context:context];							
	}else {
		[super deleteModelByID:uid context:context];		
	}
	
	return user;
}

- (NSArray*)getAllUsersWithError:(NSError **)error {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] 
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:error];
    if (!results) {
    }
    
    [request release];

    return results;
}

- (Users *)currentUser{
    NSArray *users = [self getAllUsersWithError:nil];
    
    if ([users count]){
        return [users objectAtIndex:0];
    }
    
    return nil;
}

@end