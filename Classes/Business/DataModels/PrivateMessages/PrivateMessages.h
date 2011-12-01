//
//  PrivateMessages.h
//  SuperSample
//
//  Created by Danil on 27.10.11.
//  Copyright (c) 2011 YAS. All rights reserved.
//



@interface PrivateMessages : NSManagedObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSNumber *userTo;
@property (nonatomic, retain) NSNumber *userFrom;

@end
