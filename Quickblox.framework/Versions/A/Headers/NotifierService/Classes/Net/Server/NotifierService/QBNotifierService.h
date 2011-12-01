//
//  QBNotifierService.h
//  BaseServiceStaticLibrary
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNotifierService : BaseService {

}
#pragma mark Device Token:Create

+ (NSObject<Cancelable>*)RegisterDeviceTokenAsync:(QBNDeviceToken*)deviceToken withDelegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)RegisterDeviceTokenAsync:(QBNDeviceToken*)deviceToken withDelegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark Subscriber:Create

+ (NSObject<Cancelable>*)CreateSubscriberAsync:(QBNSubscriber*)subscriber withDelegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)CreateSubscriberAsync:(QBNSubscriber*)subscriber withDelegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark Event:Create 

+ (NSObject<Cancelable>*)CreateEventAsync:(QBNEvent*)event delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)CreateEventAsync:(QBNEvent*)event delegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark Event:Fire

+ (NSObject<Cancelable>*)FireEventAsync:(NSUInteger)eventID delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)FireEventAsync:(NSUInteger)eventID delegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark Subscription

#pragma mark Subscriber

+ (NSObject<Cancelable>*)SubscribeSubscriber:(NSUInteger)subscriberID 
									 onEvent:(NSUInteger)eventID 
									delegate:(NSObject<ActionStatusDelegate>*)delegate;

+ (NSObject<Cancelable>*)SubscribeSubscriber:(NSUInteger)subscriberID 
									 onEvent:(NSUInteger)eventID 
									delegate:(NSObject<ActionStatusDelegate>*)delegate 
									 context:(void*)context;

#pragma mark User

+ (NSObject<Cancelable>*)SubscribeUser:(NSUInteger)userID 
							   onEvent:(NSUInteger)eventID 
							  delegate:(NSObject<ActionStatusDelegate>*)delegate;

+ (NSObject<Cancelable>*)SubscribeUser:(NSUInteger)userID 
							   onEvent:(NSUInteger)eventID 
							  delegate:(NSObject<ActionStatusDelegate>*)delegate 
							   context:(void*)context;

#pragma mark External User

+ (NSObject<Cancelable>*)SubscribeExternalUser:(NSUInteger)externalUserID 
									   onEvent:(NSUInteger)eventID 
									  delegate:(NSObject<ActionStatusDelegate>*)delegate;

+ (NSObject<Cancelable>*)SubscribeExternalUser:(NSUInteger)externalUserID 
									   onEvent:(NSUInteger)eventID 
									  delegate:(NSObject<ActionStatusDelegate>*)delegate 
									   context:(void*)context;


#pragma mark -


#pragma mark Task:Register Subscriber

+ (NSObject<Cancelable>*)TRegisterSubscriberForUser:(QBUUser*)user 
											 device:(QBCDevice*)device 
										   delegate:(NSObject<ActionStatusDelegate>*)delegate;

+ (NSObject<Cancelable>*)TRegisterSubscriberForUser:(QBUUser*)user 
											 device:(QBCDevice*)device 
                                          testToken:(NSString*)testToken
										   delegate:(NSObject<ActionStatusDelegate>*)delegate;

#pragma mark -

#pragma mark Task: Send Push

+ (NSObject<Cancelable>*)TSendPush:(QBNPushMessage*)pushMessage 
					toExternalUser:(NSUInteger)externalUserID 
					  eventOwnerID:(NSUInteger)eventOwnerID
						  delegate:(NSObject<ActionStatusDelegate>*)delegate;

#pragma mark -


@end
