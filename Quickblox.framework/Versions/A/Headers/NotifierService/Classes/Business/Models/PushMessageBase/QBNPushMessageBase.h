//
//  QBNPushMessageBase.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBNPushMessageBase : NSObject {
	NSMutableDictionary* payloadDict;
}
@property (nonatomic,retain) NSMutableDictionary* payloadDict;

+ (SBJsonWriter*)defaultJsonWriter;
+ (QBNPushMessageBase*)fromJson:(NSString*)json;
- (id)initWithJson:(NSString*)json;
- (id)initWithPayload:(NSDictionary*)payload;
- (NSString*)json;
- (int)charsLeft;
@end
