//
//  QBNEvent.h
//  NotifierServiceClient
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNEvent : Entity {
	NSUInteger eventOwnerID;
	enum QBNEventType type;
	enum QBNEventActionType pushActionType;
	NSMutableDictionary* message;
}
@property (nonatomic) NSUInteger eventOwnerID;
@property (nonatomic) enum QBNEventType type;
@property (nonatomic) enum QBNEventActionType pushActionType;
@property (nonatomic,retain) NSMutableDictionary* message;
- (void)prepareMessage;

#pragma mark Converters

+ (enum QBNEventActionType)actionTypeFromString:(NSString*)actionType;
+ (NSString*)actionTypeToString:(enum QBNEventActionType)actionType;

+ (enum QBNEventType)eventTypeFromString:(NSString*)eventType;
+ (NSString*)eventTypeToString:(enum QBNEventType)eventType;

+ (NSString*)messageToString:(NSDictionary*)message;
+ (NSDictionary*)messageFromString:(NSString*)message;

#pragma mark -

@end
