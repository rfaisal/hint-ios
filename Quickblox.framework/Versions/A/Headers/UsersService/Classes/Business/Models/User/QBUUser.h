//
//  QBUUser.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUser : Entity {
	
	NSUInteger ownerID;
	NSUInteger deviceID;
	NSUInteger externalUserID;
	
	NSString* fullName;
	NSString* email;
	NSString* login;
	NSString* password;
	NSString* phone;
	NSString* website;
	NSDictionary* customParameters;
	NSString* facebookAuthCode;
	NSString* twitterAauthToken;
	NSString* twitterAuthVerifier;
}
@property (nonatomic) NSUInteger ownerID;
@property (nonatomic) NSUInteger deviceID;
@property (nonatomic) NSUInteger externalUserID;
@property (nonatomic,retain) NSString* fullName;
@property (nonatomic,retain) NSString* email;
@property (nonatomic,retain) NSString* login;
@property (nonatomic,retain) NSString* password;
@property (nonatomic,retain) NSString* phone;
@property (nonatomic,retain) NSString* website;
@property (nonatomic,retain) NSDictionary* customParameters;
@property (nonatomic,retain) NSString* facebookAuthCode;
@property (nonatomic,retain) NSString* twitterAauthToken;
@property (nonatomic,retain) NSString* twitterAuthVerifier;
@end
