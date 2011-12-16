//
//  UsersProvider.h
//  SuperSample
//
//  Created by Danil on 19.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "EntityProvider.h"
@class Users;

@interface UsersProvider : EntityProvider {
    
}

@property (assign) NSUInteger currentUserID;

// Get user by mid
- (Users *)userByID:(NSManagedObjectID *)mid error:(NSError **)error;
- (Users *)userByID:(NSManagedObjectID *)mid context:(NSManagedObjectContext *)context error:(NSError **)error;

// Get user by uid
- (Users *)userByUID:(NSNumber *)uid;
- (Users *)userByUID:(NSNumber *)uid context:(NSManagedObjectContext*)context;

// Add user
- (Users *)addUser:(QBUUser *)user location:(CLLocation *)location status:(NSString *) status;
- (Users *)addUser:(QBUUser *)user location:(CLLocation *)location status:(NSString *) status context:(NSManagedObjectContext *)context;

// Update or create user
- (BOOL)updateOrCreateUser:(QBUUser *)qbUser					  
				  location:(CLLocation *)location
                    status:(NSString *) status
					 error:(NSError **)error;

- (BOOL)updateOrCreateUser:(QBUUser *)qbUser 					  
				  location:(CLLocation *)location 
                    status:(NSString *) status
				   context:(NSManagedObjectContext *)context 
					 error:(NSError **)error;

// Save User
- (BOOL) saveUser;
- (BOOL) saveUserWithContext:(NSManagedObjectContext *) context;

// current user
- (Users *)currentUserWithQBUser:(QBUUser *) user;
- (Users *)currentUser;
- (Users *)currentUserWithContext:(NSManagedObjectContext *)context;
    
- (NSArray *)getAllUsersWithError:(NSError **)error withOwn:(BOOL)withOwn;

@end