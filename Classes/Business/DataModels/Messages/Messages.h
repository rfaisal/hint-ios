//
//  Messages.h
//  SuperSample
//
//  Created by Danil on 14.09.11.
//  Copyright (c) 2011 YAS. All rights reserved.
//


@class Users;

@interface Messages : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) Users *user;
@property (nonatomic, retain) NSNumber *uid;


@end
