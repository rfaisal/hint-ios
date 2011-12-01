//
//  QBBS3Answer.h
//  Mobserv
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBS3Answer : XmlAnswer {

	NSMutableString* code;
	NSMutableString* message;
	NSMutableString* requestId;
	NSMutableString* hostId;
}
@property (nonatomic,retain) NSMutableString* code;
@property (nonatomic,retain) NSMutableString* message;
@property (nonatomic,retain) NSMutableString* requestId;
@property (nonatomic,retain) NSMutableString* hostId;
@end
