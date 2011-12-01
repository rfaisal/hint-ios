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

- (Users*)userByID:(NSManagedObjectID*)mid error:(NSError**)error;
- (Users*)userByID:(NSManagedObjectID*)mid context:(NSManagedObjectContext*)context error:(NSError**)error;

- (Users*)userByUID:(NSNumber*)uid;
- (Users*)userByUID:(NSNumber*)uid context:(NSManagedObjectContext*)context;

- (Users*)addUserWithUID:(NSNumber*)uid name:(NSString*)name location:(CLLocation*)location;
- (Users*)addUserWithUID:(NSNumber*)uid name:(NSString*)name location:(CLLocation*)location context:(NSManagedObjectContext*)context;

- (Users *)sourceUserWithID:(NSString*)uid 
						avatarID:(NSManagedObjectID*)avatarId 					   
						  operation:(NSString *)operation
							context:(NSManagedObjectContext*)context;

- (void) saveUser;
- (Users *)currentUser;
         
- (Users*)createEmptyUser;
                                            
- (NSArray*)getAllUsersWithError:(NSError **)error;

- (BOOL)updateOrCreateUser:(NSNumber*)uid					  
				  location:(CLLocation*)location
					 error:(NSError**)error;

- (BOOL)updateOrCreateUser:(NSNumber*)uid 					  
				  location:(CLLocation*)location 
				   context:(NSManagedObjectContext*)context 
					 error:(NSError**)error;
@end
