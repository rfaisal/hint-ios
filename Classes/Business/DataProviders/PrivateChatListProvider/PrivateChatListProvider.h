//
//  ChatListProvider.h
//  SuperSample
//
//  Created by Danil on 14.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "EntityProvider.h"
@class PrivateMessages;

@interface PrivateChatListProvider : EntityProvider {
    
}

- (PrivateMessages*)addMessageWithUID:(NSString*)uid text:(NSString*)text location:(NSString*)location;
- (PrivateMessages*)addMessageWithUID:(NSString*)uid 
						  text:(NSString*)text 
					  location:(NSString*)location 
					   context:(NSManagedObjectContext*)context;
- (PrivateMessages*)messageByID:(NSManagedObjectID*)mid error:(NSError**)error;


@end
