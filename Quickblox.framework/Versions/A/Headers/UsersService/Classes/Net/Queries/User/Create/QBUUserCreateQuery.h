//
//  QBUUserCreateQuery.h
//  Mobserv
//

//  Copyright 2011 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUserCreateQuery : QBUUserQuery {
	QBUUser* user;
}
@property (nonatomic,retain) QBUUser* user;
- (id)initWithUser:(QBUUser*)user;
@end
