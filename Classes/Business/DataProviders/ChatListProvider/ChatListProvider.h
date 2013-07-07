//
//  ChatListProvider.h
//  SuperSample
//
//  Created by Danil on 14.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "EntityProvider.h"
#import "Users.h"

@class Messages;

@interface ChatListProvider : EntityProvider {
    
}

// add a new one
- (Messages *)addMessageWithUID:(NSString *)uid text:(NSString *)text location:(NSString*)location user:(Users *)user date:(NSDate *)date;
- (Messages *)addMessageWithUID:(NSString *)uid 
                           text:(NSString *)text 
                       location:(NSString *)location
                           user:(Users *)user
                           date:(NSDate *)date
                        context:(NSManagedObjectContext *)context;

// search by id
- (Messages *)messageByID:(NSManagedObjectID *)mid error:(NSError **)error;

// serach by uid
- (Messages *)messageByUID:(NSNumber *)uid;
- (Messages *)messageByUID:(NSNumber *)uid context:(NSManagedObjectContext *)context;

// serach by userLogin + message
- (Messages *)messageByUser:(NSUInteger)userID message:(NSString *)text;
- (Messages *)messageByUser:(NSUInteger)userID message:(NSString *)text context:(NSManagedObjectContext *)context;

@end