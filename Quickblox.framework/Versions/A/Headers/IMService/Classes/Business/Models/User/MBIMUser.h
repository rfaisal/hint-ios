//
//  MBIMUser.h
//  Mobserv
//
//  Created by Andrey Kozlov on 3/14/11.
//  Copyright 2011 YAS. All rights reserved.
//

@interface MBIMUser : NSObject {
	NSString *login;
	MBUUser *user;
	enum MBIUserStatus status;
}

@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) MBUUser *user;

@property (nonatomic, assign) enum MBIUserStatus status;

@property (nonatomic, readonly) NSString *loginEMail;

@end
