//
//  QBUUserResetPasswordByEmailQuery.h
//  Mobserv
//
//  Created by svp on 03.08.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUserResetPasswordByEmailQuery : QBUUserQuery 
{

}

@property(nonatomic, retain) NSString *email;

- (id)initWithEmail:(NSString*)_email;

@end
