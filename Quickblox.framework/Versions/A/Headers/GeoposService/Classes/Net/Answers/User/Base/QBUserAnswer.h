//
//  UserAnswer.h
//  GeoposService
//

//  Copyright 2010 Mob1serv team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBUserAnswer : XmlAnswer {
@protected
	QBUser* user;
}
@property (nonatomic, readonly) QBUser* user;


@end
