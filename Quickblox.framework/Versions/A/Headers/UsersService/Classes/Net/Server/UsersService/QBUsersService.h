//
//  QBUsersService.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUsersService : BaseService {

}

#pragma mark User : Authenticate

+ (NSObject<Cancelable>*)authenticateUser:(QBUUser*)user delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)authenticateUser:(QBUUser*)user delegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark User : Identify

+ (NSObject<Cancelable>*)identifyUser:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)identifyUser:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark User : Logout

+ (NSObject<Cancelable>*)logoutUser:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)logoutUser:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark User Owner : Get

+ (NSObject<Cancelable>*)getUserOwnerWithID:(NSUInteger)userOwnerID delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)getUserOwnerWithID:(NSUInteger)userOwnerID delegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark User : Get

+ (NSObject<Cancelable>*)getUserWithID:(NSUInteger)userID delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)getUserWithID:(NSUInteger)userID delegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark User : Get External

+ (NSObject<Cancelable>*)getUserWithExternalID:(NSUInteger)userExternalID delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)getUserWithExternalID:(NSUInteger)userExternalID delegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark User : Create

+ (NSObject<Cancelable>*)createUser:(QBUUser*)user delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)createUser:(QBUUser*)user delegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark User Owner : Complete Facebook Authentication URL

+ (NSObject<Cancelable>*)completeFacebookAuthentication:(QBUUser*)user redirectURL:(NSString*)tredirectURL delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)completeFacebookAuthentication:(QBUUser*)user redirectURL:(NSString*)tredirectURL delegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark User Owner : Complete Twitter Authentication URL

+ (NSObject<Cancelable>*)completeTwitterAuthentication:(QBUUser*)user redirectURL:(NSString*)tredirectURL delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)completeTwitterAuthentication:(QBUUser*)user redirectURL:(NSString*)tredirectURL delegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

#pragma mark -

#pragma mark User: Reset Password by Email

+ (NSObject<Cancelable>*)resetUserPasswordByEmail:(NSString*)email delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*)resetUserPasswordByEmail:(NSString*)email delegate:(NSObject<ActionStatusDelegate>*)delegate context:(void*)context;

@end
