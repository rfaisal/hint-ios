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

@synthesize currentUserID;

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

- (Users *)userByID:(NSManagedObjectID *)mid error:(NSError **)error {	
	return [self userByID:mid context:self.managedObjectContext error:error];
}

- (Users *)userByID:(NSManagedObjectID*)mid context:(NSManagedObjectContext *)context error:(NSError **)error {
    Users *user = (Users *)[context existingObjectWithID:mid error:error];
    
	return user;
}

- (Users *)userByUID:(NSNumber *)uid {
	return [self userByUID:uid context:self.managedObjectContext];
}

- (Users *)userByUID:(NSNumber *)uid context:(NSManagedObjectContext *)context {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] 
											  inManagedObjectContext:context];
	[request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %u",[uid intValue]];
	[request setPredicate:predicate];
	NSArray* results = [context executeFetchRequest:request error:nil];
    [request release];
	
	Users *user = nil;
	if(nil != results && [results count] > 0){
		user = (Users *)[results objectAtIndex:0];
	}
    
    user.mbUser.ID = [uid intValue];
	
	return user;
}

- (BOOL)updateOrCreateUser:(QBUUser *)qbUser location:(CLLocation *)location status:(NSString *) status error:(NSError **)error{
	return [self updateOrCreateUser:qbUser location:location status:status context:self.managedObjectContext error:error];
}

- (BOOL)updateOrCreateUser:(QBUUser *)qbUser location:(CLLocation*)location status:(NSString *) status context:(NSManagedObjectContext*)context error:(NSError**)error{
    
    NSNumber *uid = [NSNumber numberWithUnsignedInteger:qbUser.ID];

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] 
											  inManagedObjectContext:context];
	[request setEntity:entity];
	[request setPredicate:[NSPredicate predicateWithFormat:@"uid == %i",[uid intValue]]];
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
    
    if(![user.status isEqualToString:status]){
        user.status = status;
        isChanged = YES;
    }
	
	return isChanged;
}

- (Users *)currentUserWithQBUser:(QBUUser *) user{
    self.currentUserID = user.ID;
    
    Users *currentUser = [self userByUID:[NSNumber numberWithUnsignedInteger:currentUserID]];
    if(currentUser == nil){
        currentUser = [self addUser:user location:nil status:nil];
    }

    return currentUser;
}

- (Users *)currentUser{
    if(currentUserID <= 0){
        return nil;
    }
    return [self userByUID:[NSNumber numberWithInteger:currentUserID]];
}

- (Users *)currentUserWithContext:(NSManagedObjectContext *)context{
    return [self userByUID:[NSNumber numberWithInteger:currentUserID] context:context];
}

- (Users *)addUser:(QBUUser *)user location: (CLLocation*) location status:(NSString *) status{
	return [self addUser:user location:location status:status context:self.managedObjectContext];
}

- (Users *)addUser:(QBUUser *) user location: (CLLocation *) location status:(NSString *) status context:(NSManagedObjectContext *)context{
    Users *model = (Users *)[NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                            inManagedObjectContext:context];
    
	model.uid = [NSNumber numberWithUnsignedInt:user.ID];
    model.mbUser = user;
    model.status = status;
    model.longitude = [NSNumber numberWithDouble: location.coordinate.longitude];
    model.latitude = [NSNumber numberWithDouble: location.coordinate.latitude];
    
	NSError **error = nil;
	if (![context save:error]) {
		return nil;
	}
    
	return model;
}

- (BOOL) saveUser{
    return [self saveUserWithContext:self.managedObjectContext];
}

- (BOOL) saveUserWithContext:(NSManagedObjectContext *) context{
    NSError **error = nil;
    
	BOOL isSaved = [context save:error];
    return isSaved;
}

- (NSArray *)getAllUsersWithError:(NSError **)error withOwn:(BOOL)withOwn{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] 
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    if(!withOwn){
        [request setPredicate:[NSPredicate predicateWithFormat:@"uid != %i",currentUserID]];
    }
    
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:error];

    [request release];

    return results;
}

@end