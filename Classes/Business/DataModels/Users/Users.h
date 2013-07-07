//
//  Users.h
//  SuperSample
//
//  Created by Danil on 19.09.11.
//  Copyright (c) 2011 YAS. All rights reserved.
//

@class SourceImages;

@class QBUUser;

@interface Users : NSManagedObject {

}

@property (nonatomic, retain) QBUUser *qbUser;
@property (nonatomic, assign) NSNumber *latitude;
@property (nonatomic, assign) NSNumber *longitude;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) SourceImages *photo;
@property (nonatomic, retain) NSNumber *uid;

@end