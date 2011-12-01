//
//  ChatListProvider.h
//  SuperSample
//
//  Created by Danil on 14.09.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import "EntityProvider.h"
@class Messages;

@interface ChatListProvider : EntityProvider {
    
}

- (Messages*)addMessageWithUID:(NSString*)uid text:(NSString*)text location:(NSString*)location;
- (Messages*)addMessageWithUID:(NSString*)uid 
						  text:(NSString*)text 
					  location:(NSString*)location 
					   context:(NSManagedObjectContext*)context;
- (Messages*)messageByID:(NSManagedObjectID*)mid error:(NSError**)error;


@end
