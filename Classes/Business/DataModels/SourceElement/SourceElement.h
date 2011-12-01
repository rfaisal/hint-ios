//
//  SourceElement.h
//  SuperSample
//
//  Created by Danil on 14.09.11.
//  Copyright (c) 2011 YAS. All rights reserved.
//



@interface SourceElement : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * downloadStatus;
@property (nonatomic, retain) NSString * global_url;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSString * local_url;
@property (nonatomic, retain) NSNumber * uid;

@end
