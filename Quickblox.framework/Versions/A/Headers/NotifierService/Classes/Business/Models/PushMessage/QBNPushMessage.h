//
//  QBNPushMessage.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNPushMessage : QBNPushMessageBase {
	NSString* alertBody;
	NSNumber* badge;
	NSString* soundFile;
	NSString* localizedBodyKey;
	NSArray* localizedBodyArguments;
	NSString* localizedActionKey;
	NSDictionary* additionalInfo;
}
@property (nonatomic,retain) NSString* alertBody;
@property (nonatomic,retain) NSNumber* badge;
@property (nonatomic,retain) NSString* soundFile;
@property (nonatomic,retain) NSString* localizedBodyKey;
@property (nonatomic,retain) NSArray* localizedBodyArguments;
@property (nonatomic,retain) NSString* localizedActionKey;
@property (nonatomic,retain) NSDictionary* additionalInfo;

@end
