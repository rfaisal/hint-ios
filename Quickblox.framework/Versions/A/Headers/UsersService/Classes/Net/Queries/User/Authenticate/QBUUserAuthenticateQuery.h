//
//  QBUAuthenticateUserQuery.h
//  Mobserv
//
//  Created by Yuriy Kuntyy on 07.05.11.
//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUserAuthenticateQuery : QBUUserQuery 
{
	QBUUser* user;
}

@property (nonatomic, retain) QBUUser* user;

- (id)initWithQBUUser:(QBUUser*)user;

@end
