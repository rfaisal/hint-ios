//
//  MBIMessage.h
//  Mobserv
//
//  Created by Andrey Kozlov on 3/14/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface MBIMMessage : NSObject {
	NSDate *sent;
	NSDate *received;
	NSString *text;
	MBIMUser *to;
	MBIMUser *from;
	NSDictionary *userInfo;
}

@property (nonatomic, retain) NSDate *sent;
@property (nonatomic, retain) NSDate *received;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) MBIMUser *to;
@property (nonatomic, retain) MBIMUser *from;
@property (nonatomic, retain) NSDictionary *userInfo;

@end
