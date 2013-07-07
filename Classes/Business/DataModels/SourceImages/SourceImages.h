//
//  SourceImages.h
//  SuperSample
//
//  Created by Danil on 14.09.11.
//  Copyright (c) 2011 YAS. All rights reserved.
//

#import "SourceElement.h"

@class Users;

@interface SourceImages : SourceElement {
@private
}

@property (nonatomic, retain) NSNumber *height;
@property (nonatomic, retain) NSNumber *width;
@property (nonatomic, retain) NSData *image;
@property (nonatomic, retain) Users *user;

@end